class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    feedback_service = FeedbackService.new(feedback_params, current_resource_owner)
    if feedback_service.store_feedback
      render json: { message: 'Feedback stored successfully' }, status: :ok
    else
      render json: { error: 'Failed to store feedback' }, status: :unprocessable_entity
    end
  end
  private
  def feedback_params
    params.require(:feedback).permit(:id, :content)
  end
end
