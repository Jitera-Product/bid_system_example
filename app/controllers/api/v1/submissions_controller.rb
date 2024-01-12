
class Api::V1::SubmissionsController < ApplicationController
  before_action :doorkeeper_authorize!, only: %i[create update destroy]

  def moderate
    submission_id = params.require(:submission_id)
    administrator_id = params.require(:administrator_id)
    action = params.require(:action)
    reason = params[:reason]

    authorize SubmissionPolicy.new(current_user, nil), :moderate?

    service = SubmissionModerationService.new
    result = service.moderate(submission_id: submission_id, administrator_id: administrator_id, action: action, reason: reason)

    render json: { message: result }, status: :ok
  rescue Pundit::NotAuthorizedError
    render json: { error: 'Not authorized to perform this action' }, status: :forbidden
  end
end
