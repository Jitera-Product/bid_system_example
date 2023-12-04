class Users::CreateService
  attr_accessor :name, :password
  def initialize(name, password)
    @name = name
    @password = password
  end
  def execute
    user = User.new(name: @name, password: @password, password_confirmation: @password)
    user.password = User.encrypt(@password)
    user.confirmation_token = SecureRandom.urlsafe_base64.to_s
    if user.save
      Registration.create(user_id: user.id)
      UserMailer.confirmation_email(user).deliver_now
      { id: user.id, name: user.name, confirmation_status: user.confirmation_status }
    else
      { error: user.errors.full_messages }
    end
  end
end
