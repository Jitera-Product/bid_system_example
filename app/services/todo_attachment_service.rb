# typed: true
class TodoAttachmentService < BaseService
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

  private

  def validate_attachment(attachment)
    raise Exceptions::AttachmentValidationError, 'Attachment must have a file path' if attachment[:file_path].blank?
    raise Exceptions::AttachmentValidationError, 'Attachment must have a file name' if attachment[:file_name].blank?
  end
end

module Exceptions
  class AttachmentValidationError < StandardError; end
end
