# rubocop:disable Style/ClassAndModuleChildren
class ProductService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Product
  end

  def execute
    user_id_equal

    name_start_with

    description_start_with

    price_equal

    stock_equal

    aproved_id_equal

    order

    paginate
  end

  def user_id_equal
    return if params.dig(:products, :user_id).blank?

    @records = Product.where('user_id = ?', params.dig(:products, :user_id))
  end

  def name_start_with
    return if params.dig(:products, :name).blank?

    @records = if records.is_a?(Class)
                 Product.where(value.query)
               else
                 records.or(Product.where('name like ?', "%#{params.dig(:products, :name)}"))
               end
  end

  def description_start_with
    return if params.dig(:products, :description).blank?

    @records = if records.is_a?(Class)
                 Product.where(value.query)
               else
                 records.or(Product.where('description like ?', "%#{params.dig(:products, :description)}"))
               end
  end

  def price_equal
    return if params.dig(:products, :price).blank?

    @records = if records.is_a?(Class)
                 Product.where(value.query)
               else
                 records.or(Product.where('price = ?', params.dig(:products, :price)))
               end
  end

  def stock_equal
    return if params.dig(:products, :stock).blank?

    @records = if records.is_a?(Class)
                 Product.where(value.query)
               else
                 records.or(Product.where('stock = ?', params.dig(:products, :stock)))
               end
  end

  def aproved_id_equal
    return if params.dig(:products, :aproved_id).blank?

    @records = if records.is_a?(Class)
                 Product.where(value.query)
               else
                 records.or(Product.where('aproved_id = ?', params.dig(:products, :aproved_id)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('products.created_at desc')
  end

  def paginate
    @records = Product.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
