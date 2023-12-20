class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_and_authorize_admin_action, only: [:create]

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
    # Check if an admin with the provided email already exists
    existing_admin = Admin.find_by(email: create_params[:email])
    if existing_admin
      render json: { error: 'Admin with this email already exists' }, status: :unprocessable_entity
      return
    end

    @admin = Admin.new(create_params.except(:password_confirmation))

    # Validate password confirmation
    unless create_params[:password] == create_params[:password_confirmation]
      render json: { error: 'Password confirmation does not match' }, status: :unprocessable_entity
      return
    end

    authorize @admin, policy_class: Api::AdminsPolicy

    if @admin.save
      render json: AdminSerializer.new(@admin).serializable_hash, status: :created
    else
      @error_object = @admin.errors.messages
      render status: :unprocessable_entity
    end
  rescue Exceptions::AuthenticationError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def update
    @admin = Admin.find_by('admins.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @admin.blank?
    authorize @admin, policy_class: Api::AdminsPolicy

    if @admin.update(update_params)
      render json: AdminSerializer.new(@admin).serializable_hash, status: :ok
    else
      @error_object = @admin.errors.messages
      render status: :unprocessable_entity
    end
  end

  private

  def authenticate_and_authorize_admin_action
    authenticate_admin!
    authorize :admin, :create?
  end

  def create_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :name)
  end

  def update_params
    params.require(:admin).permit(:name, :email)
  end
end
