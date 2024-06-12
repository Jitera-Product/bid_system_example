# rubocop:disable Style/ClassAndModuleChildren
class ProductCategoryService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = ProductCategory
  end

  def execute
    query = ProductCategory.all
    query = category_id_equal(query, params[:category_id]) if params[:category_id]
    query = product_id_equal(query, params[:product_id]) if params[:product_id]

    order

    paginate
  end

  private

  def category_id_equal(query, category_id)
    query.where(category_id: category_id)
  end

  def product_id_equal(query, product_id)
    query.where(product_id: product_id)
  end

  def order
    return if records.blank?

    @records = records.order('product_categories.created_at desc')
  end

  def paginate
    @records = ProductCategory.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren