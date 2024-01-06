class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_user!, :authorize_user_or_admin, only: [:update]
  before_action :validate_user_id, only: [:update]

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
    @user = User.find_by('users.id = ?', params[:id])
    return render json: { error: 'User not found.' }, status: :unprocessable_entity unless @user

    authorize @user, policy_class: Api::UsersPolicy

    return render json: { error: 'Username cannot exceed 50 characters.' }, status: :unprocessable_entity if update_params[:username]&.length.to_i > 50
    return render json: { error: 'Password must be at least 8 characters long.' }, status: :unprocessable_entity if update_params[:password]&.length.to_i < 8

    if User.exists?(username: update_params[:username])
      render json: { error: 'Username is already taken' }, status: :unprocessable_entity
      return
    end

    if update_params[:password].present?
      unless Devise::PasswordValidator.new.validate(update_params[:password])
        render json: { error: 'Password does not meet security requirements' }, status: :unprocessable_entity
        return
      end
    end

    update_service = UserUpdateService.new(user_id: @user.id, username: update_params[:username], password_hash: update_params[:password], role: update_params[:role], current_user: current_user)
    update_result = update_service.call

    if update_result[:error].present?
      render json: { error: update_result[:error] }, status: :unprocessable_entity
    else
      render json: { status: 200, user: { id: @user.id, username: update_params[:username], updated_at: @user.updated_at } }, status: :ok
    end
  end

  private

  def authorize_user_or_admin
    head(:unauthorized) unless current_user == @user || current_user.role == 'Administrator'
  end

  def update_params
    params.require(:user).permit(:username, :password, :role)
  end

  def validate_user_id
    unless params[:id].match?(/\A\d+\z/)
      render json: { error: 'User ID must be a number.' }, status: :bad_request
    end
  end
end
