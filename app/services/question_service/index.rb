# PATH: /app/services/question_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class QuestionService::Index < BaseService
  attr_accessor :content, :contributor_id
  def initialize(content, contributor_id)
    @content = content
    @contributor_id = contributor_id
  end
  def call
    validate_input
    question = create_question
    { message: 'Question created successfully', id: question.id }
  rescue StandardError => e
    Rails.logger.error e.message
    raise e
  end
  private
  def validate_input
    raise_error('Content cannot be empty') if content.blank?
    raise_error('Contributor does not exist') unless User.exists?(contributor_id)
  end
  def create_question
    Question.create!(content: content, user_id: contributor_id)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
