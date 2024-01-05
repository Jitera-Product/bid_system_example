class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create, :link_categories_tags, :validate, :save_attachments, :link_tag_to_todo, :link_category_to_todo]
  before_action :set_user, only: [:create]

  def create
    ActiveRecord::Base.transaction do
      todo = Todo.new(todo_params.merge(user_id: current_user.id))
      todo.validate_unique_title_for_user
      todo.validate_due_date_in_future
      validate_priority(todo_params[:priority]) if todo_params[:priority].present?
      validate_recurring(todo_params[:recurring]) if todo_params[:recurring].present?
      validate_category_ids(todo_params[:category_ids]) if todo_params[:category_ids].present?
      validate_tag_ids(todo_params[:tag_ids]) if todo_params[:tag_ids].present?
      AttachmentService.new(todo_params[:attachments]).validate_and_create_attachments if todo_params[:attachments].present?

      if todo.save
        link_categories_and_tags(todo, todo_params[:category_ids], todo_params[:tag_ids])
        render json: {
          status: 201,
          todo: todo.as_json(include: {
            user: { only: [:id, :name, :email] },
            categories: { only: [:id, :name] },
            tags: { only: [:id, :name] },
            attachments: { only: [:id, :file_path, :file_name] }
          }).merge(is_completed: false)
        }, status: :created
      else
        render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue Exceptions::AuthenticationError
    render json: { error: 'User must be authenticated.' }, status: :unauthorized
  rescue StandardError => e
    Rails.logger.error("TodosController::Create failed: #{e.message}")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  # ... other existing actions (link_categories_tags, link_category_to_todo, link_tag_to_todo, validate, save_attachments) ...

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :priority, :recurring, category_ids: [], tag_ids: [], attachments: [])
  end

  def validate_priority(priority)
    raise ActiveRecord::RecordInvalid.new(Todo.new), "Invalid priority level." unless Todo.priorities.keys.include?(priority)
  end

  def validate_recurring(recurring)
    raise ActiveRecord::RecordInvalid.new(Todo.new), "Invalid recurring option." unless Todo.recurrings.keys.include?(recurring)
  end

  def validate_category_ids(category_ids)
    if category_ids.present?
      missing_categories = category_ids - Category.where(id: category_ids).pluck(:id)
      if missing_categories.any?
        raise ActiveRecord::RecordNotFound, "One or more categories are invalid."
      end
    end
  end

  def validate_tag_ids(tag_ids)
    if tag_ids.present?
      missing_tags = tag_ids - Tag.where(id: tag_ids).pluck(:id)
      if missing_tags.any?
        raise ActiveRecord::RecordNotFound, "One or more tags are invalid."
      end
    end
  end

  def link_categories_and_tags(todo, category_ids, tag_ids)
    todo.categories = Category.find(category_ids) if category_ids.present?
    todo.tags = Tag.find(tag_ids) if tag_ids.present?
  end

  def set_user
    @user = current_resource_owner
    raise Exceptions::AuthenticationError unless @user
  end

  def current_user
    @user
  end
end
