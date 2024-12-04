# rubocop:disable Style/ClassAndModuleChildren
class ProductService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params.permit(:name, :price, :description, :stock, :approved_id, :pagination_page, :pagination_limit)

    @records = Product.all
  end

  def execute
    user_id_equal

    name_start_with

    description_contains

    price_equal_or_less_than

    stock_equal

    approved_id_equal

    order

    paginate

    @records
  end

  private

  def user_id_equal
    return if params[:user_id].blank?

    @records = records.where(user_id: params[:user_id])
  end

  def name_start_with
    return if params[:name].blank?

    @records = records.where('name LIKE ?', "#{params[:name]}%")
  end

  def description_contains
    return if params[:description].blank?

    @records = records.where('description LIKE ?', "%#{params[:description]}%")
  end

  def price_equal_or_less_than
    return if params[:price].blank?

    @records = records.where('price <= ?', params[:price])
  end

  def stock_equal
    return if params[:stock].blank?

    @records = records.where(stock: params[:stock])
  end

  def approved_id_equal
    return if params[:approved_id].blank?

    @records = records.where(approved_id: params[:approved_id])
  end

  def order
    @records = records.order(created_at: :desc)
  end

  def paginate
    page = params[:pagination_page] || 1
    limit = params[:pagination_limit] || 20
    @records = records.page(page).per(limit)
  end
end
# rubocop:enable Style/ClassAndModuleChildren