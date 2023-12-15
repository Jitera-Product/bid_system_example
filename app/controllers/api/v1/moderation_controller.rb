# FILE PATH: /app/controllers/api/v1/moderation_controller.rb

class Api::V1::ModerationController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :authorize_admin!

  def index
    type = params[:type].capitalize
    status = params[:status]

    valid_types = %w[Question Answer]
    valid_statuses = %w[pending approved rejected]

    unless valid_types.include?(type)
      return render json: { error: "Type must be either 'question' or 'answer'." }, status: :bad_request
    end

    unless valid_statuses.include?(status)
      return render json: { error: 'Invalid status type.' }, status: :bad_request
    end

    klass = type.constantize
    records = klass.where(status: status)

    # Pagination logic (assuming `paginate` method is available)
    @paginated_records = records.paginate(page: params[:page], per_page: params[:per_page])
    @total_pages = @paginated_records.total_pages

    content = @paginated_records.map do |record|
      {
        id: record.id,
        type: type.downcase,
        content: record.content,
        status: record.status,
        created_at: record.created_at.iso8601
      }
    end

    render json: {
      status: 200,
      content: content
    }, status: :ok
  rescue NameError
    render json: { error: 'Invalid type parameter' }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def authorize_admin!
    # Assuming `current_resource_owner` returns the current user and `admin?` method checks if the user is an admin
    render json: { error: 'Forbidden' }, status: :forbidden unless current_resource_owner&.admin?
  end
end
