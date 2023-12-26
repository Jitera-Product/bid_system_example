# rubocop:disable Style/ClassAndModuleChildren
class AdminService::Index
  include Pundit::Authorization

  attr_accessor :params, :records, :query, :current_user

  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user

    @records = Api::AdminsPolicy::Scope.new(current_user, Admin).resolve
  end

  def execute
    filter_by_name_prefix if params.dig(:admins, :name).present?
    filter_by_email_prefix if params.dig(:admins, :email).present?

    order_records

    paginate_records
  end

  private

  def filter_by_name_prefix
    @records = @records.where('name LIKE ?', "#{params.dig(:admins, :name)}%")
  end

  def filter_by_email_prefix
    @records = @records.where('email LIKE ?', "#{params.dig(:admins, :email)}%")
  end

  def order_records
    @records = @records.order(created_at: :desc)
  end

  def paginate_records
    page = params.dig(:pagination_page) || 1
    per_page = params.dig(:pagination_limit) || 20
    @records = @records.page(page).per(per_page)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
