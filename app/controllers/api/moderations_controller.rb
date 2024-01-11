class Api::ModerationsController < Api::BaseController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :check_admin_role, only: [:index]

  # GET /api/moderation/content
  def index
    type = params[:type]
    status = params[:status]

    # Validation for 'type' and 'status' parameters
    unless ['question', 'answer', 'feedback'].include?(type)
      render json: { error: "Type must be one of 'question', 'answer', or 'feedback'." }, status: :bad_request
      return
    end

    unless ['pending', 'approved', 'rejected'].include?(status)
      render json: { error: "Status must be one of 'pending', 'approved', or 'rejected'." }, status: :bad_request
      return
    end

    begin
      content_moderation_service = ContentModerationService.new
      content = content_moderation_service.fetch_content_by_type_and_status(type, status)
      render json: { status: 200, content: content }, status: :ok
    rescue ContentModerationService::InvalidType, ContentModerationService::InvalidStatus => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def check_admin_role
    authorize :moderation, :index?
  rescue Pundit::NotAuthorizedError => e
    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end
end
