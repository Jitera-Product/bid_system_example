class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :set_admin, only: %i[show update]
  rescue_from Exceptions::AuthenticationError, with: :handle_authentication_error

  def index
    authorize :admin, policy_class: Api::AdminsPolicy # Ensure only authorized users can access the list of admins

    service = AdminService::Index.new(params.permit!, current_resource_owner)
    result = service.execute

    if result[:error].present?
      render json: { error: result[:error] }, status: result[:status]
    else
      # Utilize PaginationService for pagination
      pagination_service = PaginationService.new(result[:admins], params[:page], params[:per_page])
      paginated_admins = pagination_service.paginate

      # Format the admin records for the response
      admin_serializer = AdminSerializer.new(paginated_admins)

      # Include the list of admins, total items, and total pages in the response
      render json: {
        status: 200,
        admins: admin_serializer.serializable_hash(data: { fields: [:id, :email, :name, :created_at, :updated_at] }),
        total_items: pagination_service.total_items,
        total_pages: pagination_service.total_pages
      }, status: :ok
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    authorize @admin, policy_class: Api::AdminsPolicy
    render 'show.json.jbuilder', status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('controller.admin.not_found') }, status: :not_found
  end

  def create
    @admin = Admin.new(create_params)

    authorize @admin, policy_class: Api::AdminsPolicy

    if @admin.save
      # Handle successful creation, e.g., render or redirect as needed
    else
      @error_object = @admin.errors.messages
      render status: :unprocessable_entity
    end
  end

  def create_params
    params.require(:admins).permit(:name, :email)
  end

  def update
    authorize @admin, policy_class: Api::AdminsPolicy

    if @admin.update(update_params)
      render json: @admin, status: :ok
    else
      @error_object = @admin.errors.messages
      render json: { errors: @error_object }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.messages }, status: :unprocessable_entity
  end

  def update_params
    params.require(:admin).permit(:name, :email)
  end

  private

  def set_admin
    @admin = Admin.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('controller.admin.not_found') }, status: :not_found
  end

  def handle_authentication_error
    render json: { error: I18n.t('controller.authentication_error') }, status: :unauthorized
  end
end
