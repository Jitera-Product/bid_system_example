class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :authenticate_inquirer, only: [:create]

  def create
    validate_feedback_params

    feedback_service = FeedbackService.new
    feedback = feedback_service.create_feedback(
      content: feedback_params[:content],
      usefulness: feedback_params[:usefulness],
      inquirer_id: current_resource_owner.id,
      question_id: feedback_params[:question_id]
    )

    if feedback.persisted?
      AiLearningModelUpdater.update_with_feedback(feedback)
      render json: { status: 201, message: 'Feedback has been recorded.', feedback: feedback.as_json }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def authenticate_inquirer
    # Assuming there's a method to authenticate inquirer similar to user authentication
    # This method should set a current_resource_owner if inquirer is authenticated
    # This method should be implemented to authenticate inquirer
  end

  def validate_feedback_params
    required_params = feedback_params
    raise ArgumentError, "The content is required." if required_params[:content].blank?
    raise ArgumentError, "Invalid value for usefulness." unless ['helpful', 'not_helpful'].include?(required_params[:usefulness])
    raise ArgumentError, "Wrong format." unless required_params[:question_id].is_a?(Numeric)
  end

  def feedback_params
    params.require(:feedback).permit(:content, :usefulness, :question_id)
  end
end
