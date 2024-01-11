
# rubocop:disable Style/ClassAndModuleChildren
class FeedbackService::Create
  include ActiveModel::Validations
  include ActiveModel::Model

  attr_accessor :feedback_params
  attr_reader :user

  validates :usefulness, inclusion: { in: [true, false] }

  def initialize(feedback_params)
    @feedback_params = feedback_params
    @user = User.find(feedback_params[:user_id])
  end

  def execute
    validate_answer_id
    authenticate_inquirer!

    feedback = Feedback.new(feedback_params)

    if feedback.save
      update_answer_ranking(feedback)
      { feedback_id: feedback.id }
    else
      { errors: feedback.errors.full_messages }
    end
  rescue StandardError => e
    handle_exceptions(e)
    { errors: e.message }
  end

  private

  def validate_answer_id
    raise 'Invalid answer_id' unless Answer.exists?(feedback_params[:answer_id])
  end

  def authenticate_inquirer!
    raise 'Unauthorized user' unless @user.role == 'Inquirer'
  end

  def create_feedback(answer_id, user_id, content, usefulness)
    raise ArgumentError, 'answer_id is required' if answer_id.blank?
    raise ArgumentError, 'user_id is required' if user_id.blank?
    raise ArgumentError, 'usefulness is required' if usefulness.nil?
    raise ArgumentError, 'Invalid usefulness value' unless [true, false].include?(usefulness)

    answer = Answer.find_by(id: answer_id)
    raise 'Answer not found' unless answer

    feedback = Feedback.create!(
      comment: content,
      usefulness: usefulness,
      answer_id: answer_id,
      user_id: user_id
    )

    update_answer_effectiveness(answer, usefulness)
    feedback
  end

  def update_answer_ranking(feedback)
    # Optional logic to update answer ranking based on feedback
  end

  def update_answer_effectiveness(answer, usefulness)
    # Logic to update answer's effectiveness score
  end

  def handle_exceptions(exception)
    # Logic to handle exceptions and provide meaningful error messages
  end
end
# rubocop:enable Style/ClassAndModuleChildren
