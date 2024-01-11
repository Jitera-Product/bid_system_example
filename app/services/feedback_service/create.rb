# rubocop:disable Style/ClassAndModuleChildren
class FeedbackService::Create
  include ActiveModel::Model

  attr_accessor :feedback_params

  validates :usefulness, inclusion: { in: [true, false] }

  def initialize(feedback_params)
    @feedback_params = feedback_params
  end

  def execute
    validate_answer_id

    feedback = Feedback.new(feedback_params)

    if feedback.save
      update_answer_ranking(feedback)
      { feedback_id: feedback.id }
    else
      { errors: feedback.errors.full_messages }
    end
  rescue StandardError => e
    { errors: e.message }
  end

  private

  def validate_answer_id
    raise 'Invalid answer_id' unless Answer.exists?(feedback_params[:answer_id])
  end

  def update_answer_ranking(feedback)
    # Optional logic to update answer ranking based on feedback
  end
end
# rubocop:enable Style/ClassAndModuleChildren
