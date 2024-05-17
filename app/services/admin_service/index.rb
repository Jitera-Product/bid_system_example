# rubocop:disable Style/ClassAndModuleChildren
class AdminService::Index
  include Pundit::Authorization

  attr_accessor :params, :records, :query

  def initialize(params, current_user = nil)
    @params = params

    @records = Api::AdminsPolicy::Scope.new(current_user, Admin).resolve
  end

  def execute
    filter_by_name

    filter_by_email

    order

    paginate
  end

  def filter_by_name
    return if params.dig(:admins, :name).blank?

    @records = @records.where('name ILIKE ?', "%#{params.dig(:admins, :name)}%")
  end

  def filter_by_email
    return if params.dig(:admins, :email).blank?

    @records = @records.where('email ILIKE ?', "%#{params.dig(:admins, :email)}%")
  end

  def order
    return if records.blank?

    @records = records.order('admins.created_at desc')
  end

  def paginate
    @records = Admin.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
