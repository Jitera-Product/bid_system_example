class Api::UsersResetPasswordRequestsController < Api::BaseController
  def create
    id = params[:id]
    return render json: { error: 'Wrong format' }, status: :bad_request unless id.is_a?(Integer)
    begin
      user = User.find(id)
      return render json: { error: 'This user is not found' }, status: :bad_request if user.nil?
      reset_password_token = SecureRandom.urlsafe_base64
      if user.update(reset_password_token: reset_password_token)
        reset_password_request = ResetPasswordRequest.create(user_id: user.id, reset_password_token: reset_password_token)
        UserMailer.reset_password_instructions(user, reset_password_token).deliver_now
        render json: { status: 200, reset_password_request: { id: reset_password_request.id, user_id: user.id } }, status: :ok
      else
        render json: { error: 'Failed to generate reset password token' }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
