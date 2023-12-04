# /app/services/users/reset_password_request_service.rb
require 'securerandom'
class Users::ResetPasswordRequestService
  def initialize(user_id)
    raise 'Wrong format' unless user_id.is_a? Integer
    @user_id = user_id
  end
  def createResetPasswordRequest
    user = User.find_by(id: @user_id)
    raise 'This user is not found' unless user
    resetPasswordToken = SecureRandom.urlsafe_base64
    user.update!(reset_password_token: resetPasswordToken)
    reset_password_request = ResetPasswordRequest.create!(user_id: @user_id, reset_password_token: resetPasswordToken)
    raise 'Failed to create reset password request' unless reset_password_request
    UserMailer.reset_password_instructions(user, resetPasswordToken).deliver_now
    { status: 200, reset_password_request: { id: reset_password_request.id, user_id: @user_id } }
  rescue => e
    { status: 500, error: e.message }
  end
end
