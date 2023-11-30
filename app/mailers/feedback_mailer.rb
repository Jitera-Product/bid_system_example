class FeedbackMailer < ApplicationMailer
  def send_confirmation(inquirer_id, feedback_id)
    @user = User.find(inquirer_id)
    @feedback = Feedback.find(feedback_id)
    mail(to: @user.email, subject: 'Feedback Confirmation')
  end
end
