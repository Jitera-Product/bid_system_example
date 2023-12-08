module Api
  class TodosController < BaseController
    include FileValidationConcern
    before_action :doorkeeper_authorize!, only: %i[create associate_categories_and_tags]
    before_action :set_todo, only: %i[associate_categories_and_tags attach_files]

    # ... other actions ...

    # POST /api/todos
    def create
      todo_params = params.permit(:title, :description, :due_date, :priority, :recurring, :category_id, :tag_id, :file_name, :file_content)
      
      # Validation for title
      return render json: { error_message: "The title is required." }, status: :unprocessable_entity if todo_params[:title].blank?
      
      # Validation for due_date
      due_date = DateTime.parse(todo_params[:due_date]) rescue nil
      return render json: { error_message: "Please provide a valid future due date and time." }, status: :unprocessable_entity if due_date.nil? || due_date < DateTime.now
      
      # Validation for priority
      valid_priorities = ['low', 'medium', 'high'] # Assuming these are the valid priorities
      return render json: { error_message: "Invalid priority level." }, status: :unprocessable_entity unless valid_priorities.include?(todo_params[:priority])
      
      validate_category_and_tag(todo_params[:category_id], todo_params[:tag_id])
      
      todo = Todo.create!(todo_params.except(:file_name, :file_content))
      
      associate_categories([todo_params[:category_id]]) if todo_params[:category_id].present?
      associate_tags([todo_params[:tag_id]]) if todo_params[:tag_id].present?
      
      attach_files_to_todo(todo, todo_params[:file_name], todo_params[:file_content]) if todo_params[:file_name].present? && todo_params[:file_content].present?
      
      render json: { status: 201, todo: todo.as_json(include: :attachments) }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error_message: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    rescue => e
      render json: { error_message: e.message }, status: :internal_server_error
    end

    # POST /api/todos/:todo_id/attachments
    def attach_files
      return render json: { error_message: "Todo item not found." }, status: :not_found unless @todo

      authorize @todo, :update?

      attachment_ids = []
      if params[:attachments].respond_to?(:each)
        params[:attachments].each do |file|
          file_name = file.original_filename
          file_content = file

          return render json: { error_message: "File name is required." }, status: :unprocessable_entity if file_name.blank?
          return render json: { error_message: "Invalid file format." }, status: :unprocessable_entity unless validate_file(file_content)

          attachment = @todo.attachments.create!(file_name: file_name, file_content: file_content)
          attachment_ids << attachment.id
        end
      else
        file_name = params[:file_name]
        file_content = params[:file_content]

        return render json: { error_message: "File name is required." }, status: :unprocessable_entity if file_name.blank?
        return render json: { error_message: "Invalid file format." }, status: :unprocessable_entity unless validate_file(file_content)

        attachment = @todo.attachments.create!(file_name: file_name, file_content: file_content)
        attachment_ids << attachment.id
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
    rescue Pundit::NotAuthorizedError
      render json: { error_message: "User is not authenticated." }, status: :unauthorized
    rescue ActiveRecord::RecordInvalid => e
      render json: { error_message: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    rescue => e
      render json: { error_message: e.message }, status: :internal_server_error
    end

    # ... other actions ...

    private

    def set_todo
      @todo = Todo.find_by(id: params[:todo_id])
    end

    def associate_categories(category_ids)
      # ... existing code ...
    end

    def associate_tags(tag_ids)
      # ... existing code ...
    end

    def validate_file(file)
      # ... existing code ...
    end

    def validate_category_and_tag(category_id, tag_id)
      errors = []
      errors << "Selected category does not exist." unless Category.exists?(category_id)
      errors << "Selected tag does not exist." unless Tag.exists?(tag_id)
      render json: { error_message: errors.join(', ') }, status: :unprocessable_entity if errors.any?
    end

    def attach_files_to_todo(todo, file_name, file_content)
      if validate_file(file_content)
        todo.attachments.create!(file_name: file_name, file_content: file_content)
      else
        render json: { error_message: "Invalid file format." }, status: :unprocessable_entity
      end
    end
  end
end
