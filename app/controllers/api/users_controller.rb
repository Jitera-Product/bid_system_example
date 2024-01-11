
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update update_profile]
  before_action :authenticate_user!, only: [:update]
  skip_before_action :doorkeeper_authorize!, only: [:authenticate, :register]

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
    # Ensure the user is authenticated and authorized to update their profile
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
    user_id = params[:id].to_i # No change here, just context for the next change
    raise StandardError.new("ID must be a number.") unless user_id.to_s == params[:id]
    raise StandardError.new("Username is required.") if params[:username].blank?
    raise StandardError.new("Password is required.") if params[:password].blank?

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

    # Use UserUpdateService to handle password hashing and updating the user record
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

  def authenticate
    username = params[:username]
    password = params[:password]

    return render json: { error: "The username is required." }, status: :bad_request if username.blank?
    return render json: { error: "The password is required." }, status: :bad_request if password.blank?

    password_hash = UserService.hash_password(password)

    user = User.find_by(username: username)
    if user&.authenticate(password_hash)
      token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id)
      log_login_attempt(user, true)
      render json: { status: 200, access_token: token.token, user: { id: user.id, username: user.username, role: user.role } }, status: :ok
    else
      log_login_attempt(user, false)
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found." }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def register
    registration_params = params.require(:user).permit(:username, :password_hash, :role)
    user_service = UserService::Register.new(registration_params)

    if user_service.username_exists?
      render json: { error: 'Username already exists.' }, status: :unprocessable_entity
      return
    end

    user = user_service.create_user

    if user.persisted?
      Devise.mailer.confirmation_instructions(user, user.confirmation_token).deliver_later
      render json: { user_id: user.id }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def authenticate_user!
    super # Assuming 'super' calls the Devise authentication method
    user = User.find_by(id: params[:id])
    unless current_user && (current_user.id == user.id || current_user.admin?)
      render json: { error: "You are not authorized to update this profile." }, status: :forbidden
    end
  end

  def user_update_service
    UserUpdateService.new(params[:user_id], update_params)
  end

  def handle_update
    authenticate_user!
    user_update_service.execute
  end

  def authentication_params
    params.require(:authentication).permit(:username, :password_hash)
  end

  def log_login_attempt(user, success)
    # Implement logging logic here
  end
end
