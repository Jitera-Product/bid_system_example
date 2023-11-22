# rubocop:disable Style/ClassAndModuleChildren
class CategoryService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Category
  end

  def execute
    created_id_equal

    name_start_with

    disabled_equal

    order

    paginate
  end

  def created_id_equal
    return if params.dig(:categories, :created_id).blank?

    @records = Category.where('created_id = ?', params.dig(:categories, :created_id))
  end

  def name_start_with
    return if params.dig(:categories, :name).blank?

    @records = if records.is_a?(Class)
                 Category.where(value.query)
               else
                 records.or(Category.where('name like ?', "%#{params.dig(:categories, :name)}"))
               end
  end

  def disabled_equal
    return if params.dig(:categories, :disabled).blank?

    @records = if records.is_a?(Class)
                 Category.where(value.query)
               else
                 records.or(Category.where('disabled = ?', params.dig(:categories, :disabled)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('categories.created_at desc')
  end

  def paginate
    @records = Category.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
