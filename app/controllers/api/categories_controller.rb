class Api::CategoriesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    @categories = CategoryService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @categories.total_pages
  end

  def show
    @category = Category.find_by!('categories.id = ?', params[:id])
  end

  def create
    @category = Category.new(create_params)

    return if @category.save

    @error_object = @category.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:categories).permit(:name, :created_id, :disabled)
  end

  def update
    @category = Category.find_by('categories.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @category.blank?

    return if @category.update(update_params)

    @error_object = @category.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:categories).permit(:name, :created_id, :disabled)
  end
end
