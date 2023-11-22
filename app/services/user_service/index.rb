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
end
# rubocop:enable Style/ClassAndModuleChildren
