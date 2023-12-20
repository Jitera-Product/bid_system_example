class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    authorize :admin, policy_class: Api::AdminsPolicy # Ensure only authorized users can access the list of admins

    service = AdminService::Index.new(params.permit!, current_resource_owner)
    @admins = service.execute

    # Utilize PaginationService for pagination
    pagination_service = PaginationService.new(@admins, params[:page], params[:per_page])
    @admins = pagination_service.paginate

    # Format the admin records for the response
    admin_serializer = AdminSerializer.new(@admins)

    # Include the list of admins, total items, and total pages in the response
    render json: {
      admins: admin_serializer.serializable_hash(data: { fields: [:id, :email, :name, :created_at, :updated_at] }),
      total_items: pagination_service.total_items,
      total_pages: pagination_service.total_pages
    }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show
    @admin = Admin.find_by!('admins.id = ?', params[:id])

    authorize @admin, policy_class: Api::AdminsPolicy
  end

  def create
    @admin = Admin.new(create_params)

    authorize @admin, policy_class: Api::AdminsPolicy

    return if @admin.save

    @error_object = @admin.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:admins).permit(:name, :email)
  end

  def update
    @admin = Admin.find_by('admins.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @admin.blank?

    authorize @admin, policy_class: Api::AdminsPolicy

    return if @admin.update(update_params)

    @error_object = @admin.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:admins).permit(:name, :email)
  end
end
