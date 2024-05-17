# rubocop:disable Style/ClassAndModuleChildren
class ProductCategoryService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = ProductCategory
  end

  def execute
    category_id_equal

    product_id_equal

    order

    paginate
  end

  def category_id_equal
    return if params[:category_id].blank?

    @records = @records.where(category_id: params[:category_id])
  end

  def product_id_equal
    return if params[:product_id].blank?

    @records = @records.where(product_id: params[:product_id])
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
