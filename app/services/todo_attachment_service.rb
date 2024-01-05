# typed: true
class TodoAttachmentService < BaseService
  MAX_FILE_SIZE = 10.megabytes # Example file size limit
  def save_attachments(todo_id, attachments)
    attachment_ids = []
    ActiveRecord::Base.transaction do
      attachments.each do |attachment|
        validate_attachment(attachment)
        raise Exceptions::AttachmentValidationError, 'File does not exist or is not accessible' unless File.exist?(attachment[:file_path])

        attachment_record = Attachment.create!(
          todo_id: todo_id,
          file_path: attachment[:file_path],
          file_name: attachment[:file_name]
        )
        attachment_ids << attachment_record.id
      end
    end
    attachment_ids
  rescue => e
    logger.error "Attachment saving failed: #{e.message}"
    raise
  end

  def attach_file_to_todo(file, todo_id)
    ActiveRecord::Base.transaction do
      todo = Todo.find(todo_id)
      validate_and_upload_file(file)

      attachment = Attachment.create!(
        todo_id: todo.id,
        file_path: file.path,
        file_name: file.original_filename
      )

      { id: attachment.id, file_name: attachment.file_name, todo_id: attachment.todo_id }
    end
  rescue ActiveRecord::RecordNotFound
    raise ActiveRecord::RecordNotFound, "Todo with ID #{todo_id} not found"
  rescue => e
    logger.error "File attachment failed: #{e.message}"
    raise
  end

  private

  def validate_and_upload_file(file)
    # Implement file validation and upload logic here
  end

  private

  def validate_attachment(attachment)
    raise Exceptions::AttachmentValidationError, 'Attachment must have a file path' if attachment[:file_path].blank?
    raise Exceptions::AttachmentValidationError, 'Attachment must have a file name' if attachment[:file_name].blank?
  end
end

module Exceptions
  class AttachmentValidationError < StandardError; end
end
