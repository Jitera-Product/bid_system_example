# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization
  include ActiveModel::Validations
  attr_accessor :params, :records, :query, :email, :phone_number, :password, :name, :username
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_format_of :phone_number, with: /\A[+]?[\d\s]+\z/
  validates_length_of :password, minimum: 8, maximum: 128
  def initialize(params, current_user = nil)
    @params = params
    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
    @email = params[:email]
    @phone_number = params[:phone_number]
    @password = params[:password]
    @name = params[:name]
    @username = params[:username]
  end
  def execute
    email_start_with
    order
    paginate
  end
  def email_start_with
    return if params.dig(:users, :email).blank?
    @records = User.where('email like ?', "%#{params.dig(:users, :email)}")
  end
  def order
    return if records.blank?
    @records = records.order('users.created_at desc')
  end
  def paginate
    @records = User.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def register_user
    return 'Invalid input' unless valid?
    existing_user = User.find_by(email: email) || User.find_by(phone_number: phone_number)
    return 'User already exists' if existing_user
    password_digest = BCrypt::Password.create(password)
    verification_code = SecureRandom.hex(10)
    user = User.create(email: email, phone_number: phone_number, password: password_digest, name: name, username: username, verification_code: verification_code, is_verified: false)
    UserMailer.with(user: user).verification_email.deliver_now
    'Registration started. Please verify your account.'
  end
  def register_social_media(social_media_platform, social_media_id)
    return 'Social media account already exists' if SocialMediaAccount.exists?(social_media_id: social_media_id)
    SocialMediaAccount.create!(social_media_platform: social_media_platform, social_media_id: social_media_id)
    'Registration successful'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
