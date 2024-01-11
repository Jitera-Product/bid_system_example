class Api::UsersPasswordsController < Api::BaseController
  before_action :authenticate_params, only: [:authenticate]

  def create
    if current_resource_owner.valid_password?(params.dig(:old_password))
      if current_resource_owner.update(password: params.dig(:new_password))
        head :ok, message: I18n.t('common.200')
      else
        render json: { messages: current_resource_owner.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      render json: { message: I18n.t('email_login.passwords.old_password_mismatch') }, status: :unprocessable_entity
    end
  end

  def authenticate
    user = User.find_by(username: authenticate_params[:username])
    if user && user.valid_password?(authenticate_params[:password_hash])
      custom_token_initialize_values(user, Doorkeeper::Application.find_by(name: 'default'))
      log_login_attempt(user, true)
      render json: { session_token: @access_token, role: user.role }, status: :ok
    else
      log_login_attempt(user, false)
      render json: error_response(nil, 'Invalid username or password'), status: :unauthorized
    end
  end

  private

  def log_login_attempt(user, success)
    # Implement logging logic here
  end

  def authenticate_params
    params.permit(:username, :password_hash)
  end
end
