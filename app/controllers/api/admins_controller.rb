class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    @admins = AdminService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @admins.total_pages
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
