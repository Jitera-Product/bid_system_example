class Api::ProductsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    @products = ProductService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @products.total_pages
  end

  def show
    begin
      @product = Product.find_by!('products.id = ?', params[:id])
    rescue ActiveRecord::RecordNotFound => e
      base_render_record_not_found(e)
    end
  end

  def create
    @product = Product.new(create_params)

    authorize @product, policy_class: Api::ProductsPolicy

    return if @product.save

    @error_object = @product.errors.messages

    render status: :unprocessable_entity
  end

  def update
    @product = Product.find_by('products.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @product.blank?

    authorize @product, policy_class: Api::ProductsPolicy

    return if @product.update(update_params)

    @error_object = @product.errors.messages

    render status: :unprocessable_entity
  end

  private

  def create_params
    params.require(:products).permit(:name, :price, :description, :image, :user_id, :stock, :aproved_id)
  end

  def update_params
    params.require(:products).permit(:name, :price, :description, :image, :user_id, :stock, :aproved_id)
  end

  # Assuming the base_render_record_not_found method is defined in the BaseController or included module
  def base_render_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end