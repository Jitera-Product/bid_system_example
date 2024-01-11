class Api::ModerationsController < Api::BaseController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :check_admin_role, only: [:index, :update]

  # GET /api/moderation/content
  def index
    type = params[:type]
    status = params[:status]

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

  # PUT /api/moderate/:type/:id
  def update
    type = params[:type]
    id = params[:id].to_i
    status = params[:status]

    return render json: { error: "Invalid type specified." }, status: :bad_request unless %w[question answer].include?(type)
    return render json: { error: "Wrong format." }, status: :bad_request unless id.is_a?(Integer)
    return render json: { error: "Invalid status value." }, status: :bad_request unless valid_status?(status)

    record = type == "question" ? Question.find_by(id: id) : Answer.find_by(id: id)
    return render json: { error: "Record not found." }, status: :not_found unless record

    if record.update(status: status)
      render json: { status: 200, message: "The content has been successfully moderated." }, status: :ok
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def check_admin_role
    action = action_name.to_sym
    authorize :moderation, action
  rescue Pundit::NotAuthorizedError => e
    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end

  def valid_status?(status)
    ['pending', 'approved', 'rejected'].include?(status)
  end
end
