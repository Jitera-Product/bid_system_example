module Api
  class TodosController < BaseController
    include FileValidationConcern
    before_action :doorkeeper_authorize!, only: %i[associate_categories_and_tags]
    before_action :set_todo, only: %i[associate_categories_and_tags attach_files]

    # ... other actions ...

    # POST /api/todos/:todo_id/attachments
    def attach_files
      return render json: { error_message: "Todo item not found." }, status: :not_found unless @todo

      authorize @todo, :update?

      attachment_ids = []
      params[:attachments].each do |file|
        file_name = file.original_filename
        file_content = file

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

    # ... other private methods ...
  end
end
