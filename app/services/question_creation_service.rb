# typed: true
class BaseService
  def initialize(*_args); end

  def logger
    @logger ||= Rails.logger
  end
end

class QuestionCreationService < BaseService
  def initialize(title, content, user_id, category_ids)
    @title = title
    @content = content
    @user_id = user_id
    @category_ids = category_ids
  end

  def call
    ActiveRecord::Base.transaction do
      authenticate_contributor!
      validate_presence_of_title_content_and_user_id!
      validate_user_exists!
      validate_category_ids_exist!

      question = Question.create!(
        title: @title,
        content: @content,
        user_id: @user_id
      )

      create_category_mappings_for(question)

      question.id
    rescue ActiveRecord::RecordNotFound => e
      logger.error "Record not found: #{e.message}"
      raise
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Validation failed: #{e.message}"
      raise
    rescue StandardError => e
      logger.error "Error creating question: #{e.message}"
      raise
    end
  end

  private

  def authenticate_contributor!
    user = User.find_by(id: @user_id)
    unless user&.role == 'Contributor'
      raise StandardError, 'User is not authorized to create a question'
    end
  end

  def validate_presence_of_title_content_and_user_id!
    if @title.blank? || @content.blank? || @user_id.blank?
      raise StandardError, 'Title, content, and user ID cannot be blank'
    end
  end

  def validate_user_exists!
    unless User.exists?(@user_id)
      raise StandardError, 'User does not exist'
    end
  end

  def validate_category_ids_exist!
    @category_ids.each do |category_id|
      unless QuestionCategory.exists?(category_id)
        raise StandardError, "Category with id #{category_id} does not exist"
      end
    end
  end

  def create_category_mappings_for(question)
    @category_ids.each do |category_id|
      QuestionCategoryMapping.create!(
        question_id: question.id,
        question_category_id: category_id
      )
    end
  end
end
