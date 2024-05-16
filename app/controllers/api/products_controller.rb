class Api::ProductsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    @products = ProductService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @products.total_pages
  end

  def show
    @product = Product.find_by!('products.id = ?', params[:id])
  end

  def create
    @product = Product.new(create_params)

    authorize @product, policy_class: Api::ProductsPolicy

    if @product.save
      render :create, status: :created
    else
      render json: error_response(@product, StandardError.new(@product.errors.full_messages.join(', '))), status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: error_response(@product, e), status: :unprocessable_entity
  end

  def create_params
    params.require(:product).permit(:name, :price, :description, :image, :user_id, :stock, :approved_id)
  end

  def update
    @product = Product.find_by('products.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @product.blank?

    authorize @product, policy_class: Api::ProductsPolicy

    if @product.update(update_params)
      render :update
    else
      render json: error_response(@product, StandardError.new(@product.errors.full_messages.join(', '))), status: :unprocessable_entity
    end
  end

  def update_params
    params.require(:product).permit(:name, :price, :description, :image, :user_id, :stock, :approved_id)
  end
end