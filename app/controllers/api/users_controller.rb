class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_admin!, only: %i[create update destroy]
  before_action :set_user, only: %i[show update destroy]
  before_action :validate_unique_username, only: %i[create update]

  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
    render json: { users: @users, total_pages: @total_pages }, status: :ok
  end

  def show
    authorize @user, policy_class: Api::UsersPolicy
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)

    authorize @user, policy_class: Api::UsersPolicy

    if @user.save
      UserMailer.confirmation_email(@user).deliver_later
      render json: { message: 'User created successfully', user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @user, policy_class: Api::UsersPolicy

    if @user.update(user_params)
      render json: { message: 'User updated successfully', user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user, policy_class: Api::UsersPolicy

    if @user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_admin!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_resource_owner&.admin?
  end

  def set_user
    @user = User.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @user
  end

  def user_params
    params.require(:user).permit(:username, :password_hash, :role)
  end

  def validate_unique_username
    if User.exists?(username: user_params[:username])
      render json: { error: 'Username already taken' }, status: :unprocessable_entity
      return false
    end
    true
  end
end
