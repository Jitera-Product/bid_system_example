# rubocop:disable Style/ClassAndModuleChildren
class ProductCategoryService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = ProductCategory
  end

  def execute
    @page = params[:page] || 1

    product_id_equal

    order

    paginate
  end

  def category_id_equal
    return if params.dig(:product_categories, :category_id).blank?

    @records = ProductCategory.where('category_id = ?', params.dig(:product_categories, :category_id))
  end

  def product_id_equal
    return if params.dig(:product_categories, :product_id).blank?

    @records = if records.is_a?(Class)
                 ProductCategory.where(value.query)
               else
                 records.or(ProductCategory.where('product_id = ?', params.dig(:product_categories, :product_id)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('product_categories.created_at desc')
  end

  def paginate
    if records.blank? || records.is_a?(Class)
      @records = ProductCategory.none
      @total_pages = 0
    else
      @records = records.page(@page).per(params.dig(:pagination_limit) || 20)
      @total_pages = @records.total_pages
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
