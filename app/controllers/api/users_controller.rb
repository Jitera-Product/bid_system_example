
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

    if @user.update(update_params)
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
    params.require(:users).permit(:username, :password_hash)
  end
end
