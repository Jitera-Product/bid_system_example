# /app/services/moderation_service.rb
class ModerationService
  include ActiveModel::Model

  attr_accessor :submission_id, :content_type, :administrator_id, :action

  def initialize(submission_id, content_type, administrator_id, action)
    @submission_id = submission_id
    @content_type = content_type
    @administrator_id = administrator_id
    @action = action
  end

  def moderate
    ActiveRecord::Base.transaction do
      validate_administrator
      submission = find_submission

      case action
      when 'approve'
        submission.update!(status: 'approved')
        moderation_status = 'approved'
      when 'reject'
        submission.update!(status: 'rejected')
        # Optionally remove the submission from the database if rejected
        submission.destroy if content_type == 'Answer' # Assuming only Answers can be removed
        moderation_status = 'rejected'
      else
        raise StandardError, "Invalid action: #{action}"
      end

      AuditLogger.log(administrator_id, submission_id, content_type, action)

      { moderation_status: moderation_status }
    end
  end

  private

  def validate_administrator
    admin = User.find_by(id: administrator_id, role: 'Administrator')
    raise StandardError, 'Invalid administrator' unless admin
  end

  def find_submission
    submission = case content_type
                 when 'Question'
                   Question.find_by(id: submission_id)
                 when 'Answer'
                   Answer.find_by(id: submission_id)
                 else
                   raise StandardError, "Invalid content type: #{content_type}"
                 end
    raise StandardError, 'Submission not found' unless submission

    submission
  end
end
