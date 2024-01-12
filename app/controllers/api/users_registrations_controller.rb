
class Api::UsersRegistrationsController < Api::BaseController
  before_action :validate_registration_params, only: [:create]

  def create
    user_service = UserService::Create.new(create_params)
    @user = user_service.execute
    if @user.persisted?
      custom_token_initialize_values(@user, Doorkeeper::Application.first)
      DeviseMailer.confirmation_instructions(@user, @user.confirmation_token).deliver_later
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

  def validate_registration_params
    params.require(:user).permit(:username, :password_hash, :role)
  end

  def create_params
    params.require(:user).permit(:username, :password_hash, :role)
  end
end
