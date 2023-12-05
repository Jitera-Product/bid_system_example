# PATH: /app/services/user_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization
  attr_accessor :params, :records, :query
  def initialize(params, current_user = nil)
    @params = params
    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
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
  def reset_password(email)
    user = User.find_by_email(email)
    if user
      reset_code = SecureRandom.urlsafe_base64
      user.update(reset_password_token: reset_code)
      UserMailer.password_reset(user).deliver_now
      I18n.t('devise.passwords.send_instructions')
    else
      I18n.t('devise.failure.not_found_in_database')
    end
  end
  def register_social_media(social_media_platform, social_media_id)
    return 'Social media account already exists' if SocialMediaAccount.exists?(social_media_id: social_media_id)
    SocialMediaAccount.create!(social_media_platform: social_media_platform, social_media_id: social_media_id)
    'Registration successful'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
