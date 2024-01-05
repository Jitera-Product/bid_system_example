# typed: true
module Api
  class AttachmentsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_attachment_creation!, only: [:create]

    def create
      todo = Todo.find_by(id: attachment_params[:todo_id])
      unless todo
        render json: { error: 'Todo item not found' }, status: :not_found
        return
      end

      begin
        attachment_service = TodoAttachmentService.new
        attachment_ids = attachment_service.save_attachments(todo.id, [attachment_params])
        render json: { attachments: attachment_ids.map { |id| Attachment.find(id) } }, status: :created
      rescue Exceptions::AttachmentValidationError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue => e
        render json: { error: 'Failed to save attachment' }, status: :internal_server_error
      end
    end

    private

    def attachment_params
      params.require(:attachment).permit(:file, :todo_id)
    end

    def authorize_attachment_creation!
      # Add authorization logic here
    end
  end
end
