class ProductService
  # ... [other methods in the ProductService]

  # Add the new method list_products according to the guidelines
  def list_products(params)
    # Initialize the query scope for the Product model
    products_scope = Product.all

    # Apply filters based on the presence of keys in the params hash
    products_scope = products_scope.where(user_id: params[:user_id]) if params[:user_id].present?
    products_scope = products_scope.where('name LIKE ?', "#{params[:name]}%") if params[:name].present?
    products_scope = products_scope.where('description LIKE ?', "#{params[:description]}%") if params[:description].present?
    products_scope = products_scope.where(price: params[:price]) if params[:price].present?
    products_scope = products_scope.where(stock: params[:stock]) if params[:stock].present?
    products_scope = products_scope.where(approved_id: params[:approved_id]) if params[:approved_id].present?

    # Order the products by created_at in descending order
    products_scope = products_scope.order(created_at: :desc)

    # Paginate the results with sensible defaults
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    paginated_products = products_scope.page(page).per(per_page)

    # Return a hash with records and pagination details
    {
      records: paginated_products,
      pagination: {
        current_page: paginated_products.current_page,
        total_pages: paginated_products.total_pages,
        total_count: paginated_products.total_count
      }
    }
  end

  # ... [other methods in the ProductService]
end
