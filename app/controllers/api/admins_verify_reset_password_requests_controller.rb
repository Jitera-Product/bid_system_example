class Api::AdminsVerifyResetPasswordRequestsController < Api::BaseController
  def create
    token = Devise.token_generator.digest(Admin, :reset_password_token, params.dig(:reset_token))

    @admin = Admin.find_by(reset_password_token: token)

    if @admin.blank? || params.dig(:reset_token).blank? || params.dig(:password).blank? || params.dig(:password_confirmation).blank?
      @error_message = I18n.t('reset_password.invalid_token')
    elsif !@admin.reset_password_period_valid?
      @error_message = I18n.t('errors.messages.expired')
    elsif @admin.reset_password(params.dig(:password), params.dig(:password), params.dig(:password_confirmation))
    else
      @error_message = @admin.errors.full_messages
    end
    if @error_message.present?
      render json: { error_message: @error_message }, status: :unprocessable_entity
    else
      head :ok, message: I18n.t('common.200')
    end
  end
end
