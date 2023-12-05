class Api::UsersRegistrationsController < Api::BaseController
  def create
    user_service = UserService.new
    if user_service.validate_user_params(create_params)
      if user_service.check_existing_user(create_params[:email], create_params[:phone_number])
        render json: { message: I18n.t('email_login.registrations.user_exists') }, status: :unprocessable_entity
      else
        @user = user_service.create_user(create_params)
        if @user.persisted?
          user_service.send_verification_code(@user)
          render json: { message: I18n.t('email_login.registrations.success') }, status: :ok
        else
          render json: { error_messages: @user.errors.messages, message: I18n.t('email_login.registrations.failed_to_sign_up') }, status: :unprocessable_entity
        end
      end
    else
      render json: { message: I18n.t('email_login.registrations.invalid_params') }, status: :unprocessable_entity
    end
  end
  private
  def create_params
    params.require(:user).permit(:password, :password_confirmation, :email, :phone_number, :name, :username)
  end
end
