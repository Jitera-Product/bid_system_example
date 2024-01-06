
# app/services/moderation_service.rb

module Services
  class ContentNotFoundError < StandardError; end
  class ModerationService
    include Pundit::Authorization

    def initialize(submission_id:, moderator_id:, action:)
      @submission_id = submission_id
      @moderator_id = moderator_id
      @action = action.to_s.downcase
    end

    def perform
      authenticate_administrator
      submission = validate_submission

      case @action
      when 'approve'
        approve_submission(submission)
      when 'reject'
        reject_submission(submission)
      when 'edit'
        edit_submission(submission, edited_content) # Assuming edited_content is provided
      else
        raise ArgumentError, I18n.t('common.invalid')
      end

      { message: I18n.t('common.success'), action: @action, submission_id: @submission_id }
    rescue ContentNotFoundError => e
      { error: e.message, action: @action, submission_id: @submission_id }
    end

    private

    def authenticate_administrator
      admin = Admin.find(@moderator_id)
      raise Exceptions::AuthenticationError unless admin.role == 'Administrator'
    end
    
    def validate_submission
      submission = Submission.find_by(id: @submission_id)
      raise ActiveRecord::RecordNotFound, I18n.t('common.404') unless submission
      submission
    end

    def approve_submission(submission)
      submission.update!(status: 'approved')
      log_moderation_action('approved')
    rescue ActiveRecord::RecordInvalid => e
      raise ContentNotFoundError, I18n.t('moderation.approval_failed')
    end

    def reject_submission(submission)
      submission.update!(status: 'rejected')
      log_moderation_action('rejected')
    end

    def edit_submission(submission, edited_content)
      # Assume edits are provided in a separate parameter or method
      submission.update!(edited_content)
      log_moderation_action('edited')
    end

    def log_moderation_action(action)
      Transaction.create!(
        admin_id: @moderator_id,
        submission_id: @submission_id,
        action: action
      )
    end
  end
end
