
# rubocop:disable Style/ClassAndModuleChildren
class QuestionSubmissionService
  include SanitizationHelper
  attr_reader :question_params, :tags, :current_user

  def initialize(question_params, tags, current_user)
    @question_params = question_params
    @tags = tags
    @current_user = current_user
  end

  def call
    authenticate_contributor
    validate_presence_of_parameters
    question_params[:title] = sanitize(question_params[:title])
    question_params[:content] = sanitize(question_params[:content])

    question_id = nil
    ActiveRecord::Base.transaction do
      question = Question.create!(question_params.merge(user_id: current_user.id, created_at: Time.current, updated_at: Time.current))
      associate_tags_with_question(question) if tags.present?
      question_id = question.id
    end
    question_id
  rescue ActiveRecord::RecordInvalid => e
    raise StandardError, e.message
  end

  private
  
  def authenticate_contributor
    raise StandardError, 'User is not authenticated or authorized to submit questions' unless current_user&.role == 'contributor'
  end

  def sanitize(text)
    # Assuming SanitizationHelper provides a sanitize method
    SanitizationHelper.sanitize(text)
  end

  def validate_presence_of_parameters
    raise StandardError, 'Missing required parameters' if question_params[:title].blank? || question_params[:content].blank? || question_params[:category].blank?
  end

  def associate_tags_with_question(question)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by!(name: tag_name)
      QuestionTag.create!(question_id: question.id, tag_id: tag.id)
    rescue ActiveRecord::RecordInvalid => e
      raise StandardError, "Failed to associate tag with question: #{e.message}"
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
