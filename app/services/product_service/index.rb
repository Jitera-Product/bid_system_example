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
    order
    paginate
  end

  private

  def filter_by_user_id
    return if params[:user_id].blank?

    @records = @records.where(user_id: params[:user_id])
  end

  def filter_by_name
    return if params[:name].blank?

    @records = @records.where('name LIKE ?', "%#{params[:name]}%")
  end

  def filter_by_description
    return if params[:description].blank?

    @records = @records.where('description LIKE ?', "%#{params[:description]}%")
  end

  def filter_by_price
    return if params[:price].blank?

    @records = @records.where(price: params[:price])
  end

  def filter_by_stock
    return if params[:stock].blank?

    @records = @records.where(stock: params[:stock])
  end

  def filter_by_approved_id
    return if params[:approved_id].blank?

    @records = @records.where(approved_id: params[:approved_id])
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