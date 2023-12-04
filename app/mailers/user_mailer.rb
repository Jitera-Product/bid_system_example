class UserMailer < ApplicationMailer
  ...
  def manual_review_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Your documents are under review') do |format|
      format.html { render 'manual_review_notification' }
    end
  end
  ...
end
