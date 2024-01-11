
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

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
    @user = User.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?

    authorize @user, policy_class: Api::UsersPolicy

    return if @user.update(update_params)

    @error_object = @user.errors.messages
    render json: { error: @error_object }, status: :unprocessable_entity
  end

  def update_params
    params.require(:user).permit(:username, :password_hash, :role)
  end
end

private

def authenticate_user!
  oauth_tokens_concern.authenticate_user!(params[:user_id])
end

def user_update_service
  UserUpdateService.new(params[:user_id], update_params)
end

def handle_update
  authenticate_user!
  user_update_service.execute
end
