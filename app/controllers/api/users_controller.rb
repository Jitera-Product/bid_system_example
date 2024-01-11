class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update update_profile]
  before_action :authenticate_user!, only: [:update, :update_profile]
  skip_before_action :doorkeeper_authorize!, only: [:authenticate, :register]

  # ... existing code for other actions ...

  def update_profile
    user_id = params[:id].to_i
    validate_profile_update_params

    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound if user.blank?
    raise Pundit::NotAuthorizedError unless user.id == current_resource_owner.id

    # Check for username uniqueness before updating
    if User.exists?(username: params[:username])
      render json: { error: "Username already taken." }, status: :unprocessable_entity
      return
    end

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

  private

  def validate_profile_update_params
    raise StandardError.new("Wrong format.") unless params[:id].to_s =~ /^\d+$/
    raise StandardError.new("The username is required.") if params[:username].blank?
    raise StandardError.new("The password is required.") if params[:password].blank?
  end

  # ... rest of the private methods ...
end
