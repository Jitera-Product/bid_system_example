class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update update_profile]

  def index
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

  def update_profile
    user_id = params[:id].to_i
    raise StandardError.new("ID must be a number.") unless user_id.to_s == params[:id]
    raise StandardError.new("Username is required.") if params[:username].blank?
    raise StandardError.new("Password is required.") if params[:password].blank?

    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound if user.blank?
    raise Pundit::NotAuthorizedError unless user.id == current_resource_owner.id

    password_hash = UserService.hash_password(params[:password])
    update_params = { username: params[:username], password_hash: password_hash }

    result = UserUpdateService.new.update_user_profile(user.id, update_params[:username], update_params[:password_hash])

    if result[:update_status]
      render json: { status: 200, user: user.as_json(only: [:id, :username, :updated_at]) }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found." }, status: :not_found
  rescue Pundit::NotAuthorizedError
    render json: { error: "You are not authorized to update this profile." }, status: :forbidden
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
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
