class Users::CreateService
  attr_accessor :name, :password
  def initialize(name, password)
    @name = name
    @password = password
  end
  def execute
    raise StandardError.new("The name is required.") if @name.blank?
    raise StandardError.new("The password is required.") if @password.blank?
    user = User.new(name: @name, password: @password, password_confirmation: @password)
    user.password = User.encrypt(@password)
    user.confirmation_token = SecureRandom.urlsafe_base64.to_s
    if user.save
      Registration.create(user_id: user.id)
      UserMailer.confirmation_email(user).deliver_now
      { status: 200, user: { id: user.id, name: user.name, confirmation_token: user.confirmation_token } }
    else
      { error: user.errors.full_messages }
    end
  end
end
