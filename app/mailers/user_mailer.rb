class UserMailer < ApplicationMailer
  ...
  def reset_password_instructions(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Reset password instructions')
  end
  ...
end
