class Api::UsersRegistrationsController < Api::BaseController
  before_action :validate_registration_params, only: [:create]

  def create
    @user = User.new(user_creation_params)
    if @user.save
      if Rails.env.staging?
        # to show token in staging
        token = @user.respond_to?(:confirmation_token) ? @user.confirmation_token : ''
        render json: { message: I18n.t('common.200'), token: token }, status: :ok and return
      else
        head :ok, message: I18n.t('common.200') and return
      end
    else
      error_messages = @user.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end

  def create_session
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password_hash])
      token = Doorkeeper::AccessToken.create(resource_owner_id: user.id)
      log_login_attempt(user.username, true)
      render json: { token: token.token, role: user.role }, status: :ok
    else
      log_login_attempt(params[:username], false)
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  private

  def user_creation_params
    # Merged the new create_params with the existing registration_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email, :role)
  end

  def validate_registration_params
    # Updated to check for presence of password and email instead of password_hash
    unless user_creation_params[:username].present? && user_creation_params[:password].present? && user_creation_params[:email].present?
      render json: { error: 'Username, password, and email are required.' }, status: :bad_request and return
    end

    # Check if the role is included in the User roles, if role is provided
    if user_creation_params[:role].present? && !User.roles.include?(user_creation_params[:role])
      render json: { error: 'Invalid role.' }, status: :bad_request and return
    end

    if User.find_by(username: user_creation_params[:username])
      render json: { error: 'Username already taken.' }, status: :unprocessable_entity and return
    end
  end

  def log_login_attempt(username, success)
    status = success ? 'successful' : 'failed'
    Rails.logger.info "Login attempt for #{username} was #{status} at #{Time.current}"
  end
end
