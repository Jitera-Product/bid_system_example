class Users::SendConfirmationService
  attr_accessor :user
  def initialize(user)
    @user = user
  end
  def execute
    begin
      UserMailer.confirmation_email(user).deliver_now
      return { status: :success, message: 'Confirmation email sent successfully.' }
    rescue => e
      return { status: :error, message: e.message }
    end
  end
end
