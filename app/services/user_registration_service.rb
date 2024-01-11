class UserRegistrationService
  include ActiveModel::Validations

  validates :username, presence: true
  validates :password_hash, presence: true
  validates :role, inclusion: { in: %w[contributor inquirer administrator] }

  def initialize(username:, password_hash:, role:)
    @username = username
    @password_hash = password_hash
    @role = role
  end

  def call
    validate!

    raise 'Username already taken' if User.exists?(username: @username)

    user = User.new(
      username: @username,
      password_hash: BCrypt::Password.create(@password_hash),
      role: @role,
      created_at: Time.current,
      updated_at: Time.current
    )

    user.save!
    user.id
  rescue ActiveModel::ValidationError, ActiveRecord::RecordInvalid => e
    raise e.message
  end
end
