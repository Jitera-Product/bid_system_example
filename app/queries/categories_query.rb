class CategoriesQuery
  def initialize(scope = Category.all)
    @scope = scope
  end

  def by_created_id(created_id)
    @scope.where(created_id: created_id)
  end

  def with_name_prefix(prefix)
    @scope.where('name LIKE ?', "#{prefix}%")
  end

  def disabled(status)
    @scope.where(disabled: status)
  end

  def order_by_creation_date_desc
    @scope.order(created_at: :desc)
  end
end
