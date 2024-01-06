
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_user!, :authorize_user_or_admin, only: [:update]

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
    # Ensure the user is authorized to update the profile
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?

    authorize @user, policy_class: Api::UsersPolicy

    # Check if the current user has the authority to change roles
    if update_params[:role].present? && current_user.role != 'Administrator'
      render json: { error: 'You do not have permission to change user roles' }, status: :forbidden
      return
    end

    # Check if the username is unique
    if User.exists?(username: update_params[:username])
      render json: { error: 'Username is already taken' }, status: :unprocessable_entity
      return
    end

    # If a new password is provided, validate it
    if update_params[:password_hash].present?
      unless Devise::PasswordValidator.new.validate(update_params[:password_hash])
        render json: { error: 'Password does not meet security requirements' }, status: :unprocessable_entity
        return
      end
    end

    # Call the UserUpdateService to perform the update
    update_status = UserUpdateService.new(user_id: @user.id, username: update_params[:username], password_hash: update_params[:password_hash], role: update_params[:role]).execute

    if update_status.success?
      # Return a JSON response with the user ID and success message
      render json: { user_id: @user.id, message: 'User profile updated successfully', status: :ok, updated_fields: update_params.keys }
    else
      @error_object = @user.errors.messages
      render json: { errors: @error_object }, status: :unprocessable_entity
    end
  end

  private

  def authorize_user_or_admin
    head(:unauthorized) unless current_user == @user || current_user.role == 'Administrator'
  end

  def update_params
    params.require(:users).permit(:username, :password_hash, :role)
  end
end
