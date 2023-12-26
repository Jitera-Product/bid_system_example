# rubocop:disable Style/ClassAndModuleChildren
class CategoryService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @query = CategoriesQuery.new
  end

  def execute
    filter_by_created_id
    filter_by_name_prefix
    filter_by_disabled_status
    order_by_creation_date_desc
    paginate
  end

  def filter_by_created_id
    return if params.dig(:categories, :created_id).blank?

    @query = @query.filter_by_created_id(params.dig(:categories, :created_id))
  end

  def filter_by_name_prefix
    return if params.dig(:categories, :name).blank?

    @query = @query.filter_by_name_prefix(params.dig(:categories, :name))
  end

  def filter_by_disabled_status
    return if params.dig(:categories, :disabled).nil?

    @query = @query.filter_by_disabled_status(params.dig(:categories, :disabled))
  end

  def order_by_creation_date_desc
    @query = @query.order_by_creation_date_desc
  end

  def paginate
    current_page = params.dig(:pagination, :page) || 1
    per_page = params.dig(:pagination, :per_page) || 20
    @records = Pagination.paginate(@query, current_page, per_page)
  end

  def list_categories
    execute
    {
      records: @records,
      pagination: {
        current_page: @records.current_page,
        per_page: @records.per_page,
        total_pages: @records.total_pages,
        total_count: @records.total_count
      }
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
