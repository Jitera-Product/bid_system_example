# typed: ignore
module AttachmentService
  class Index < BaseService
    include ActiveModel::Validations

    MAX_FILE_SIZE = 10.megabytes
    ALLOWED_FILE_FORMATS = %w[image/jpeg image/png application/pdf].freeze

    def attach_file_to_todo(file, todo_id)
      ActiveRecord::Base.transaction do
        todo = Todo.find_by(id: todo_id)
        raise StandardError, 'Todo not found' unless todo

        validate_file(file)

        attachment = Attachment.create!(
          file_path: file.tempfile.path,
          file_name: file.original_filename,
          todo_id: todo_id
        )

        { id: attachment.id, file_name: attachment.file_name, todo_id: attachment.todo_id }
      end
    rescue => e
      logger.error(e.message)
      raise
    end

    private

    def validate_file(file)
      raise StandardError, 'Invalid file format' unless ALLOWED_FILE_FORMATS.include?(file.content_type)
      raise StandardError, 'File size exceeds the allowed limit' if file.size > MAX_FILE_SIZE
    end
  end
end
