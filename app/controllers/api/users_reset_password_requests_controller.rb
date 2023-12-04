class Api::UsersResetPasswordRequestsController < Api::BaseController
  def create
    @user = User.find_by('email = ?', params.dig(:email))
    @user.send_reset_password_instructions if @user.present?
    head :ok, message: I18n.t('common.200')
  end
  def reset_password_request
    @user = User.find(params[:id])
    reset_password_token = SecureRandom.urlsafe_base64
    if @user.update(reset_password_token: reset_password_token)
      ResetPasswordRequest.create(user_id: @user.id, reset_password_token: reset_password_token)
      UserMailer.reset_password_instructions(@user, reset_password_token).deliver_now
      render json: { id: @user.id, name: @user.name, status: 'Reset password request sent' }, status: :ok
    else
      render json: { error: 'Failed to generate reset password token' }, status: :unprocessable_entity
    end
  end
end
