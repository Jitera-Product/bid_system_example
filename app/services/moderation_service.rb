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

  # New method added to validate content
  def self.validate_content(content)
    # Implement content validation logic here
    # For example, check for profanity or spam
    # This is a placeholder for actual validation logic
    profanity_filter = %w[badword inappropriate]
    spam_indicator = 'http://'

    if profanity_filter.any? { |word| content.include?(word) } || content.include?(spam_indicator)
      false
    else
      true
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

# Additional code to handle question editing
class QuestionEditingService
  include ActiveModel::Model

  attr_accessor :question_id, :content, :user_id

  def initialize(question_id, content, user_id)
    @question_id = question_id
    @content = content
    @user_id = user_id
  end

  def edit_question
    ActiveRecord::Base.transaction do
      user = validate_user
      question = find_question

      raise StandardError, 'Content cannot be empty' if content.blank?
      raise StandardError, 'Content does not meet guidelines' unless ModerationService.validate_content(content)

      question.update!(content: content)

      { message: 'Question has been updated.' }
    end
  end

  private

  def validate_user
    user = User.find_by(id: user_id, role: 'Contributor')
    raise StandardError, 'Invalid user or insufficient permissions' unless user
    user
  end

  def find_question
    question = Question.find_by(id: question_id, user_id: user_id)
    raise StandardError, 'Question not found or not owned by user' unless question
    question
  end
end
