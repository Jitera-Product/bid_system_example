
class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :doorkeeper_authorize!, only: %i[update_role], if: -> { current_resource_owner.role == 'Administrator' }

  VALID_ROLES = %w[Administrator Moderator User].freeze

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

  def update_role
    user_id = params[:user_id]
    new_role = params[:new_role]

    user = User.find_by!(id: user_id)
    raise ArgumentError, 'Invalid role' unless VALID_ROLES.include?(new_role)

    authorize user, :manage?, policy_class: Api::AdminsPolicy

    user.role = new_role
    user.save!

    Rails.logger.info "User role updated: #{user_id}, new role: #{new_role}"
    render json: { message: 'Role updated successfully', user: user }, status: :ok
  end
end
