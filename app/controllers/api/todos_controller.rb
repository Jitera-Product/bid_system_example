class Api::TodosController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create, :link_categories_tags, :validate, :save_attachments, :link_tag_to_todo, :link_category_to_todo]

  def create
    ActiveRecord::Base.transaction do
      todo = Todo.new(todo_params.merge(user_id: current_user.id))
      todo.validate_unique_title_for_user
      todo.validate_due_date_in_future
      validate_priority(todo_params[:priority]) if todo_params[:priority].present?
      validate_category_ids(todo_params[:category_ids]) if todo_params[:category_ids].present?
      validate_tag_ids(todo_params[:tag_ids]) if todo_params[:tag_ids].present?
      AttachmentService.new(todo_params[:attachments]).validate_and_create_attachments if todo_params[:attachments].present?

      if todo.save
        link_categories_and_tags(todo, todo_params[:category_ids], todo_params[:tag_ids])
        render json: {
          status: 201,
          todo: todo.as_json(include: {
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

  def link_categories_tags
    todo = Todo.find_by(id: params[:todo_id])
    return render status: :not_found, json: { error: 'Todo not found' } if todo.nil?

    category_ids = params[:category_ids]
    tag_ids = params[:tag_ids]

    begin
      ActiveRecord::Base.transaction do
        validate_category_ids(category_ids) if category_ids.present?
        validate_tag_ids(tag_ids) if tag_ids.present?
        link_categories_and_tags(todo, category_ids, tag_ids)
      end

      render json: { status: 200, message: 'Todo item linked with categories and tags successfully.' }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { errors: e.message }, status: :internal_server_error
    end
  end

  def link_category_to_todo
    ActiveRecord::Base.transaction do
      todo = Todo.find(params[:todo_id])
      return render json: { error: 'Todo not found' }, status: :not_found unless todo

      unless Category.exists?(params[:category_id])
        return render json: { error: 'Category not found' }, status: :unprocessable_entity
      end

      TodoCategory.create!(todo_id: params[:todo_id], category_id: params[:category_id])
      render json: { message: 'Category linked to todo successfully' }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def link_tag_to_todo
    todo = Todo.find_by(id: params[:todo_id])
    return render json: { error: 'Todo item not found.' }, status: :not_found if todo.nil?

    tag = Tag.find_by(id: params[:tag_id])
    return render json: { error: 'Tag not found.' }, status: :unprocessable_entity if tag.nil?

    begin
      ActiveRecord::Base.transaction do
        todo.tags << tag
      end
      render json: { message: 'Tag linked to todo item successfully.' }, status: :ok
    rescue => e
      render json: { errors: e.message }, status: :internal_server_error
    end
  end

  def validate
    todo = Todo.new(todo_params.slice(:user_id, :title, :due_date))
    todo.validate_unique_title_for_user
    todo.validate_due_date_in_future

    if todo.errors.empty?
      render json: { status: 200, message: "Validation passed." }, status: :ok
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Exceptions::AuthenticationError
    render json: { error: 'User must be authenticated.' }, status: :unauthorized
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :conflict
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def save_attachments
    todo = Todo.find_by(id: params[:todo_id])
    return render json: { error: 'Todo item not found.' }, status: :not_found if todo.nil?

    begin
      attachments = AttachmentService.new(todo, todo_params[:attachments]).create_attachments
      render json: { status: 200, attachments: attachments.map { |a| a.slice(:id, :file_path, :file_name) } }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :priority, :recurring, category_ids: [], tag_ids: [], attachments: [])
  end

  def validate_priority(priority)
    raise ActiveRecord::RecordInvalid.new(Todo.new), "Invalid priority level." unless Todo.priorities.keys.include?(priority)
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
end
