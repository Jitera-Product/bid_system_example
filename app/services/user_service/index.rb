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
  def update(user_id, restrict_features)
    return { status: 'error', message: 'Wrong format' } unless user_id.is_a?(Integer)
    user = User.find_by(id: user_id)
    return { status: 'error', message: 'User not found' } unless user
    begin
      user.update!(restrict_features: restrict_features)
      { status: 'success', message: "User's features have been restricted due to incomplete KYC process." }
    rescue StandardError => e
      { status: 'error', message: e.message }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
