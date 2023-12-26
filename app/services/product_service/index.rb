# rubocop:disable Style/ClassAndModuleChildren
class ProductService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Product
  end

  def execute
    filter_by_user_id
    filter_by_name
    filter_by_description
    filter_by_price
    filter_by_stock
    filter_by_approved_id

    sort_products
    paginate_products

    { records: @records, pagination: pagination_details }
  end

  private

  def filter_by_user_id
    return unless params.dig(:products, :user_id)

    @records = @records.where(user_id: params.dig(:products, :user_id))
  end

  def filter_by_name
    return unless params.dig(:products, :name)

    @records = @records.where('name LIKE ?', "#{params.dig(:products, :name)}%")
  end

  def filter_by_description
    return unless params.dig(:products, :description)

    @records = @records.where('description LIKE ?', "#{params.dig(:products, :description)}%")
  end

  def filter_by_price
    return unless params.dig(:products, :price)

    @records = @records.where(price: params.dig(:products, :price))
  end

  def filter_by_stock
    return unless params.dig(:products, :stock)

    @records = @records.where(stock: params.dig(:products, :stock))
  end

  def filter_by_approved_id
    return unless params.dig(:products, :approved_id)

    @records = @records.where(approved_id: params.dig(:products, :approved_id))
  end

  def sort_products
    @records = @records.order(created_at: :desc)
  end

  def paginate_products
    page_number = params.dig(:pagination, :page) || 1
    per_page = params.dig(:pagination, :limit) || 20
    @records = @records.page(page_number).per(per_page)
  end

  def pagination_details
    {
      current_page: @records.current_page,
      total_pages: @records.total_pages,
      total_records: @records.total_count
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
