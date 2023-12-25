class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update destroy]
  before_action :authenticate_admin!, only: %i[create update destroy]
  before_action :set_user, only: %i[show update destroy]
  before_action :validate_user_params, only: %i[create update]

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

    user_parameters = user_params
    user_parameters[:password] = user_parameters.delete(:password_hash) if user_parameters[:password_hash]

    if @user.update(user_parameters)
      # Log the profile edit action
      UserActivity.create(
        user_id: @user.id,
        activity_type: 'profile_edit',
        activity_description: "User updated profile with username: #{@user.username}"
      )
      render json: { message: 'User updated successfully', user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user, policy_class: Api::UsersPolicy

    if @user.destroy
      head :no_content
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
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:username, :password_hash, :role).tap do |user_params|
      validate_user_params(user_params)
    end
  end

  def validate_user_params(user_params = nil)
    user_params ||= self.user_params
    errors = []
    errors << 'The username is required.' if user_params[:username].blank?
    errors << 'The password hash is required.' if user_params[:password_hash].blank?
    errors << 'Invalid role value.' unless ['Contributor', 'Inquirer', 'Administrator'].include?(user_params[:role])
    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity
      false
    else
      validate_unique_username(user_params)
    end
  end

  def validate_unique_username(user_params)
    if params[:action] == 'update' && @user.username == user_params[:username]
      return true
    end

    if User.exists?(username: user_params[:username])
      render json: { error: 'Username already taken' }, status: :unprocessable_entity
      return false
    end
    true
  end
end
