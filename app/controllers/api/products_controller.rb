class Api::ProductsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  # Define a list of permitted parameters for filtering and pagination
  INDEX_PARAMS_WHITELIST = [:page, :per_page, :sort, :filter, :user_id, :name, :description, :price, :stock, :approved_id].freeze

  def index
    begin
      # Use strong parameters to permit only the allowed parameters
      permitted_params = params.permit(INDEX_PARAMS_WHITELIST)
      # Use ProductService::Index to retrieve products
      @products = ProductService::Index.list_products(permitted_params, current_resource_owner)
      @total_pages = @products.total_pages
      render json: { products: @products, total_pages: @total_pages }, status: :ok
    rescue Exceptions::AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show
    @product = Product.find_by!('products.id = ?', params[:id])
  end

  def create
    @product = Product.new(create_params)

    authorize @product, policy_class: Api::ProductsPolicy

    return if @product.save

    @error_object = @product.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:products).permit(:name, :price, :description, :image, :user_id, :stock, :approved_id)
  end

  def update
    @product = Product.find_by('products.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @product.blank?

    authorize @product, policy_class: Api::ProductsPolicy

    return if @product.update(update_params)

    @error_object = @product.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:products).permit(:name, :price, :description, :image, :user_id, :stock, :approved_id)
  end
end
