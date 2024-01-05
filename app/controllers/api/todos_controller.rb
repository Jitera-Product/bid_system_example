class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create, :link_categories_tags]

  def create
    ActiveRecord::Base.transaction do
      todo = Todo.new(todo_params)
      todo.validate_unique_title_for_user
      todo.validate_due_date_in_future
      validate_category_ids(todo_params[:category_ids])
      validate_tag_ids(todo_params[:tag_ids])
      AttachmentService.new(todo_params[:attachments]).validate_and_create_attachments if todo_params[:attachments].present?

      if todo.save
        link_categories_and_tags(todo, todo_params[:category_ids], todo_params[:tag_ids])
        render json: { todo_id: todo.id }, status: :created
      else
        render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def link_categories_tags
    todo = Todo.find_by(id: params[:todo_id])
    return render status: :not_found, json: { error: 'Todo not found' } if todo.nil?

    category_ids = params[:category_ids]
    tag_ids = params[:tag_ids]

    ActiveRecord::Base.transaction do
      link_categories_and_tags(todo, category_ids, tag_ids)
    end

    linked_categories = todo.categories
    linked_tags = todo.tags

    render status: :ok, json: {
      linked_categories: linked_categories.as_json(only: [:id, :name]),
      linked_tags: linked_tags.as_json(only: [:id, :name])
    }
  rescue => e
    render status: :internal_server_error, json: { error: e.message }
  end

  private

  def todo_params
    params.require(:todo).permit(:user_id, :title, :description, :due_date, :priority, :recurring, category_ids: [], tag_ids: [], attachments: [])
  end

  def validate_category_ids(category_ids)
    raise ActiveRecord::RecordNotFound unless Category.where(id: category_ids).count == category_ids.count
  end

  def validate_tag_ids(tag_ids)
    raise ActiveRecord::RecordNotFound unless Tag.where(id: tag_ids).count == tag_ids.count
  end

  def link_categories_and_tags(todo, category_ids, tag_ids)
    missing_categories = category_ids - Category.where(id: category_ids).pluck(:id)
    unless missing_categories.empty?
      raise ActiveRecord::RecordNotFound, "Categories not found: #{missing_categories.join(', ')}"
    end

    missing_tags = tag_ids - Tag.where(id: tag_ids).pluck(:id)
    unless missing_tags.empty?
      raise ActiveRecord::RecordNotFound, "Tags not found: #{missing_tags.join(', ')}"
    end

    todo.categories << Category.find(category_ids)
    todo.tags << Tag.find(tag_ids)
  end
end
