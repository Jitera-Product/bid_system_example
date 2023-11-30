class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  before_action :authorize_inquirer!, only: %i[create]
  def create
    feedback_service = FeedbackService.new(feedback_params, current_resource_owner)
    if feedback_service.create_feedback
      render json: { status: 200, feedback: feedback_service.feedback }, status: :ok
    else
      render json: { error: feedback_service.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def feedback_params
    params.require(:feedback).permit(:content, :inquirer_id, :answer_id)
  end
  def authorize_inquirer!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_resource_owner.role == 'inquirer'
  end
end
