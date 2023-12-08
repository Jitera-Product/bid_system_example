module Api
  class TodosController < BaseController
    include FileValidationConcern
    before_action :doorkeeper_authorize!, only: %i[associate_categories_and_tags attach_files validate_creation]
    before_action :set_todo, only: %i[associate_categories_and_tags attach_files]

    # ... other actions ...

    # POST /api/todos/attach_files
    def attach_files
      return render json: { error_message: "Todo item not found." }, status: :not_found unless @todo

      authorize @todo, :update?

      attachment_ids = []
      params[:attachments].each do |file|
        if validate_file(file)
          attachment = @todo.attachments.create!(file_name: file.original_filename, file_content: file)
          attachment_ids << attachment.id
        else
          return render json: error_response(nil, StandardError.new("Invalid file format or size")), status: :unprocessable_entity
        end
      end

      render json: {
        status: 201,
        attachments: attachment_ids.map do |id|
          attachment = @todo.attachments.find(id)
          {
            id: id,
            todo_id: @todo.id,
            file_name: attachment.file_name,
            created_at: attachment.created_at
          }
        end
      }, status: :created
    rescue Pundit::NotAuthorizedError => e
      render json: error_response(nil, e), status: :unauthorized
    rescue ActiveRecord::RecordInvalid => e
      render json: error_response(nil, e.record.errors.full_messages.join(', ')), status: :unprocessable_entity
    rescue => e
      render json: error_response(nil, e), status: :internal_server_error
    end

    # POST /api/todos/:todo_id/categories_tags
    def associate_categories_and_tags
      if @todo.nil?
        render json: { error_message: 'Todo not found' }, status: :not_found
        return
      end

      ActiveRecord::Base.transaction do
        if params[:category_ids].present?
          category_errors = associate_categories(params[:category_ids])
          if category_errors.any?
            render json: { error_message: category_errors.join(', ') }, status: :unprocessable_entity
            return
          end
        elsif params[:category_id].present?
          category = Category.find_by(id: params[:category_id])
          unless category
            render json: { error_message: 'Selected category does not exist.' }, status: :unprocessable_entity
            return
          end
          TodoCategory.create!(todo: @todo, category: category)
        end

        if params[:tag_ids].present?
          tag_errors = associate_tags(params[:tag_ids])
          if tag_errors.any?
            render json: { error_message: tag_errors.join(', ') }, status: :unprocessable_entity
            return
          end
        elsif params[:tag_id].present?
          tag = Tag.find_by(id: params[:tag_id])
          unless tag
            render json: { error_message: 'Selected tag does not exist.' }, status: :unprocessable_entity
            return
          end
          TodoTag.create!(todo: @todo, tag: tag)
        end
      end

      render json: { status: 200, message: 'Categories and tags associated successfully.' }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { error_message: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error_message: e.message }, status: :internal_server_error
    end

    # POST /api/todos/validate
    def validate_creation
      title = params[:title]
      due_date = params[:due_date]

      if title.blank? || due_date.blank?
        render json: { message: "Title and due date are required." }, status: :bad_request
        return
      end

      if Todo.where(user: current_user, title: title).exists?
        render json: { message: "A todo with this title already exists." }, status: :conflict
        return
      end

      if Todo.where(user: current_user).where.not(id: params[:todo_id]).where('due_date = ?', due_date).exists?
        render json: { message: "The due date conflicts with another scheduled todo." }, status: :conflict
        return
      end

      render json: { message: "No conflicts detected. Todo can be created." }, status: :ok
    rescue => e
      render json: { error_message: e.message }, status: :internal_server_error
    end

    private

    def set_todo
      @todo = Todo.find_by(id: params[:todo_id])
    end

    def associate_categories(category_ids)
      errors = []
      category_ids.each do |category_id|
        category = Category.find_by(id: category_id)
        if category
          TodoCategory.create!(todo: @todo, category: category)
        else
          errors << "Category with id #{category_id} not found"
        end
      end
      errors
    end

    def associate_tags(tag_ids)
      errors = []
      tag_ids.each do |tag_id|
        tag = Tag.find_by(id: tag_id)
        if tag
          TodoTag.create!(todo: @todo, tag: tag)
        else
          errors << "Tag with id #{tag_id} not found"
        end
      end
      errors
    end

    def validate_file(file)
      # Assuming FileValidationConcern provides a method 'valid_file?' to validate the file
      valid_file?(file)
    end
  end
end
