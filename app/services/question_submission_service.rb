# rubocop:disable Style/ClassAndModuleChildren
class QuestionSubmissionService
  attr_reader :question_params, :tags, :current_user

  def initialize(question_params, tags, current_user)
    @question_params = question_params
    @tags = tags
    @current_user = current_user
  end

  def call
    validate_presence_of_parameters

    question_id = nil
    ActiveRecord::Base.transaction do
      question = Question.create!(question_params.merge(user_id: current_user.id))
      associate_tags_with_question(question)
      question_id = question.id
    end
    question_id
  rescue ActiveRecord::RecordInvalid => e
    raise StandardError, e.message
  end

  private

  def validate_presence_of_parameters
    raise StandardError, 'Missing required parameters' if question_params[:title].blank? || question_params[:content].blank? || question_params[:category].blank?
  end

  def associate_tags_with_question(question)
    tags.each do |tag_name|
      tag = Tag.find_or_create_by!(name: tag_name)
      QuestionTag.create!(question_id: question.id, tag_id: tag.id)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
