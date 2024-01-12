
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

  def create_user_with_session_token(username:, password_hash:, role:)
    user = User.create!(username: username, password_hash: password_hash, role: role)
    session_token = CustomAccessToken.create!(resource_owner_id: user.id)
    session_token.token
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::AuthenticationError, e.message
  end

  private

  # Additional private methods if needed
end
# rubocop:enable Style/ClassAndModuleChildren
