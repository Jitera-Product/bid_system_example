class Api::AdminsRegistrationsController < Api::BaseController
  def create
    @admin = Admin.new(create_params)
    if @admin.save
      if Rails.env.staging?
        # to show token in staging
        token = @admin.respond_to?(:confirmation_token) ? @admin.confirmation_token : ''
        render json: { message: I18n.t('common.200'), token: token }, status: :ok and return
      else
        head :ok, message: I18n.t('common.200') and return
      end
    else
      error_messages = @admin.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end

  def create_params
    params.require(:admin).permit(:password, :password_confirmation, :name, :email)
  end
end
