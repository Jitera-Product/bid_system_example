class Api::ProductCategoriesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    page = params[:page].to_i
    if page < 1
      render json: { error: I18n.t('activerecord.errors.messages.pagination.page_must_be_greater_than_zero') }, status: :bad_request
      return
    end

    begin
      @product_categories = ProductCategoryService::Index.new(params.permit!, current_resource_owner).execute
      @total_pages = @product_categories.total_pages
    rescue ArgumentError
      render json: { error: I18n.t('activerecord.errors.messages.pagination.wrong_format') }, status: :bad_request
    end
  end

  def show
    @product_category = ProductCategory.find_by!('product_categories.id = ?', params[:id])
  end

  def create
    @product_category = ProductCategory.new(create_params)

    return if @product_category.save

    @error_object = @product_category.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:product_categories).permit(:category_id, :product_id)
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