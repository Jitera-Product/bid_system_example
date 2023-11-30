class Api::FeedbacksController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  def create
    feedback_service = FeedbackService.new(feedback_params, current_resource_owner)
    if feedback_service.create_feedback
      render json: { id: feedback_service.feedback.id, message: 'Feedback successfully created' }, status: :created
    else
      render json: { error: feedback_service.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def feedback_params
    params.require(:feedback).permit(:content, :inquirer_id, :answer_id)
  end
end
