# rubocop:disable Style/ClassAndModuleChildren
class ProductCategoryService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = ProductCategory
  end

  def execute
    filter_by_category_id
    filter_by_product_id
    order_records
    paginate_records
    {
      records: @records,
      pagination: pagination_details
    }
  end

  private

  def filter_by_category_id
    category_id = params.dig(:product_categories, :category_id)
    @records = @records.where(category_id: category_id) if category_id.present?
  end

  def filter_by_product_id
    product_id = params.dig(:product_categories, :product_id)
    @records = @records.where(product_id: product_id) if product_id.present?
  end

  def order_records
    @records = @records.order(created_at: :desc)
  end

  def paginate_records
    page = params.dig(:pagination, :page) || 1
    limit = params.dig(:pagination, :limit) || 20
    @records = @records.page(page).per(limit)
  end

  def pagination_details
    {
      current_page: @records.current_page,
      total_pages: @records.total_pages,
      total_count: @records.total_count
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
