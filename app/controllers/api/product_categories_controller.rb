class Api::ProductCategoriesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    @product_categories = ProductCategoryService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @product_categories.total_pages
  end

  def show
    @product_category = ProductCategory.find_by!('product_categories.id = ?', params[:id])
  end

  # Define a "create" action that instantiates a new "ProductCategory" with "create_params"
  # and handles success or failure.
  def create
    product_category = ProductCategory.new(create_params)
    if product_category.save
      render json: product_category, status: :ok
    else
      base_render_unprocessable_entity(product_category.errors)
    end
  end

  def create_params
    params.require(:product_category).permit(:category_id, :product_id)
  end

  def update
    @product_category = ProductCategory.find_by('product_categories.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @product_category.blank?

    return if @product_category.update(update_params)

    @error_object = @product_category.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:product_categories).permit(:category_id, :product_id)
  end
end