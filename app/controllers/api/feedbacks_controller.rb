class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  before_action :validate_params, only: %i[create]
  def create
    if current_resource_owner.nil?
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end
    feedback_service = FeedbackService.new(feedback_params, current_resource_owner)
    if feedback_service.valid?
      if feedback_service.store_feedback
        render json: { status: 200, feedback: feedback_service.feedback }, status: :ok
      else
        render json: { error: 'Internal Server Error' }, status: :internal_server_error
      end
    else
      render json: { error: 'Bad Request', messages: feedback_service.errors.full_messages }, status: :bad_request
    end
  end
  private
  def feedback_params
    params.require(:feedback).permit(:id, :match_id, :feedback)
  end
  def validate_params
    render json: { error: 'Wrong format' }, status: :unprocessable_entity unless params[:id].is_a?(Integer) && params[:match_id].is_a?(Integer)
    render json: { error: 'The feedback is required.' }, status: :bad_request if params[:feedback].blank?
  end
end
