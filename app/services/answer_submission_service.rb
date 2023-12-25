# rubocop:disable Style/ClassAndModuleChildren
class AnswerSubmissionService
  include Pundit::Authorization

  def initialize(user)
    @user = user
  end

  def submit_answer(question_id, content, created_at, updated_at)
    # Authenticate the contributor
    raise Pundit::NotAuthorizedError unless Pundit.policy!(@user, :answer_submission).submit?

    # Validate the input data
    validator = AnswerValidator.new(question_id: question_id, content: content)
    raise CustomException::ValidationFailed, validator.errors unless validator.valid?

    # Create a new Answer record
    begin
      answer = Answer.create!(
        question_id: question_id,
        content: content,
        created_at: created_at,
        updated_at: updated_at
      )
    rescue ActiveRecord::RecordInvalid => e
      raise CustomException::SubmissionFailed, e.message
    end

    answer.id
  end
end
# rubocop:enable Style/ClassAndModuleChildren

# Assuming AnswerValidator and CustomException classes are defined as per the guideline
class AnswerValidator
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :content, :question_id

  validates :content, presence: true, length: { minimum: 10 }
  validate :question_must_exist

  def initialize(attributes = {})
    @content = attributes[:content]
    @question_id = attributes[:question_id]
  end

  private

  def question_must_exist
    errors.add(:question_id, 'must exist') unless Question.exists?(@question_id)
  end
end

module CustomException
  class ValidationFailed < StandardError; end
  class SubmissionFailed < StandardError; end
end
