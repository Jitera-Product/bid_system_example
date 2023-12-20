class Api::AdminsResetPasswordRequestsController < Api::BaseController
  before_action :authorize_request, only: [:update]

  def create
    @admin = Admin.find_by('email = ?', params.dig(:email))
    @admin.send_reset_password_instructions if @admin.present?
    head :ok, message: I18n.t('common.200')
  end

  def update
    reset_password_token = params[:reset_password_token]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    return render json: { error: I18n.t('admins_reset_password_requests.errors.token_blank') }, status: :unprocessable_entity if reset_password_token.blank?
    return render json: { error: I18n.t('admins_reset_password_requests.errors.password_confirmation_mismatch') }, status: :unprocessable_entity if password != password_confirmation

    admin = Admin.with_reset_password_token(reset_password_token)

    if admin&.reset_password(password, password_confirmation)
      # Clear the reset_password_token after successful password reset
      admin.update(reset_password_token: nil)
      render json: { message: I18n.t('admins_reset_password_requests.success.password_reset') }, status: :ok
    else
      render json: { error: I18n.t('admins_reset_password_requests.errors.invalid_token') }, status: :unprocessable_entity
    end
  end

  private

  def authorize_request
    # Assuming there's a method in Api::BaseController or included module to check authorization
    authorize!(:update, Admin)
  end

  def reset_password_params
    params.permit(:reset_password_token, :password, :password_confirmation)
  end
end
