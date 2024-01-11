
class Api::UsersRegistrationsController < Api::BaseController
  before_action :validate_registration_params, only: [:create]

  def create
    @user = User.new(registration_params)
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

  private

  def registration_params
    params.require(:user).permit(:username, :password_hash, :role)
  end

  def validate_registration_params
    unless registration_params[:username].present? && registration_params[:password_hash].present?
      render json: { error: 'Username and password hash are required.' }, status: :bad_request and return
    end

    unless User.roles.include?(registration_params[:role])
      render json: { error: 'Invalid role.' }, status: :bad_request and return
    end

    if User.find_by(username: registration_params[:username])
      render json: { error: 'Username already taken.' }, status: :unprocessable_entity and return
    end
  end
end
