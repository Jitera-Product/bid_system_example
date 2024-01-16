
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_user!, only: [:update_role]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy
  end

  def create
    @user = User.new(create_params)

    authorize @user, policy_class: Api::UsersPolicy

    return if @user.save

    @error_object = @user.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:users).permit(:email)
  end

  def update
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?

    authorize @user, policy_class: Api::UsersPolicy

    return if @user.update(update_params)

    @error_object = @user.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:users).permit(:email)
  end

  def update_role
    target_user_id = params[:id]
    new_role = params[:role]

    user = User.find_by(id: target_user_id)
    return render json: { message: 'User not found' }, status: :not_found if user.nil?

    authorize user, policy_class: Api::UsersPolicy

    if User.roles.include?(new_role)
      user.role = new_role
      user.save
      render json: { message: 'User role updated successfully' }
    else
      render json: { message: 'Invalid role' }, status: :unprocessable_entity
    end
  end
end
