
class Api::V1::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def moderate_content
    authorize Admin, :moderate_content?

    content_id = params[:content_id]
    content_type = params[:content_type]
    action = params[:action]

    moderation_service = ContentModerationService.new
    moderation_service.moderate(content_id, content_type, action, current_resource_owner.id)

    log_moderation_action(content_id, content_type, action, current_resource_owner)

    message_key = action == 'approve' ? 'content_approved' : 'content_rejected'
    render json: { message: I18n.t(message_key) }, status: :ok
  rescue ActiveRecord::RecordNotFound, Exceptions::ContentNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def log_moderation_action(content_id, content_type, action, admin)
    # Log the action with timestamp and admin details
  end

  def index
    # inside service params are checked and whiteisted
    @admins = AdminService::Index.new(params.permit!, current_resource_owner).execute
  end
end
