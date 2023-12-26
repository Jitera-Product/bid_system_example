class Api::CategoriesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    service = CategoryService::Index.new(filtered_params, current_resource_owner)
    result = service.execute
    render json: {
      records: result.records,
      pagination: {
        total_pages: result.total_pages,
        current_page: result.current_page,
        next_page: result.next_page,
        prev_page: result.prev_page,
        total_count: result.total_count
      }
    }
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

  private

  def filtered_params
    permitted_params = params.permit!.to_h
    permitted_params[:filters] ||= {}
    permitted_params[:filters][:created_id] = params[:created_id] if params[:created_id].present?
    permitted_params[:filters][:name_prefix] = params[:name_prefix] if params[:name_prefix].present?
    permitted_params[:filters][:disabled] = params[:disabled] if params[:disabled].present?
    permitted_params[:order] = { created_at: :desc }
    permitted_params
  end
end
