class Api::UsersRegistrationsController < Api::BaseController
  before_action :validate_registration_params, only: [:create, :register]

  def create
    @user = User.new(user_creation_params)
    if @user.save
      if Rails.env.staging?
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

  def register
    @user = User.new(user_creation_params)
    if @user.save
      render json: { status: 201, user: @user.as_json(only: [:id, :username, :role, :created_at]) }, status: :created
    else
      error_messages = @user.errors.messages
      status_code = error_messages.include?(:username) ? :bad_request : :unprocessable_entity
      render json: { error_messages: error_messages }, status: status_code
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
    params.require(:user).permit(:username, :password, :password_confirmation, :email, :role)
  end

  def validate_registration_params
    params = user_creation_params
    errors = {}
    errors[:username] = 'The username is required.' unless params[:username].present?
    errors[:password] = 'The password must be at least 8 characters long.' if params[:password].to_s.length < 8
    errors[:role] = 'Invalid role specified.' unless ['contributor', 'inquirer', 'administrator'].include?(params[:role])
    
    if errors.any?
      render json: { error: errors }, status: :bad_request and return
    end

    if User.exists?(username: params[:username])
      render json: { error: 'Username already taken.' }, status: :unprocessable_entity and return
    end
  end

  def log_login_attempt(username, success)
    status = success ? 'successful' : 'failed'
    Rails.logger.info "Login attempt for #{username} was #{status} at #{Time.current}"
  end
end
