# /app/services/moderation_service.rb
class ModerationService
  include ActiveModel::Model

  attr_accessor :content_id, :content_type, :admin_id, :action

  # Renamed parameters to match the new code's naming convention
  def initialize(content_id, content_type, admin_id, action)
    @content_id = content_id
    @content_type = content_type
    @admin_id = admin_id
    @action = action
  end

  def moderate
    ActiveRecord::Base.transaction do
      validate_administrator
      validate_moderation_queue_entry
      moderation_queue_entry = find_moderation_queue_entry

      case action
      when 'approve'
        update_content_status('approved')
        moderation_queue_entry.update!(status: 'approved') if moderation_queue_entry
        moderation_status = 'approved'
      when 'reject'
        update_content_status('rejected')
        moderation_queue_entry.update!(status: 'rejected') if moderation_queue_entry
        send_rejection_notification
        moderation_status = 'rejected'
      else
        raise StandardError, "Invalid action: #{action}"
      end

      # Renamed administrator_id to admin_id to match the new code's naming convention
      AuditLogger.log(admin_id, content_id, content_type, action)

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
    admin = User.find_by(id: admin_id, role: 'Administrator')
    raise StandardError, 'Invalid administrator' unless admin
  end

  def validate_moderation_queue_entry
    entry = ModerationQueue.find_by(content_id: content_id, content_type: content_type)
    raise StandardError, 'Moderation queue entry not found' unless entry
  end

  def find_moderation_queue_entry
    ModerationQueue.find_by(content_id: content_id, content_type: content_type)
  end

  def update_content_status(new_status)
    content = case content_type
              when 'Question'
                Question.find_by(id: content_id)
              when 'Answer'
                Answer.find_by(id: content_id)
              else
                raise StandardError, "Invalid content type: #{content_type}"
              end
    raise StandardError, 'Content not found' unless content

    content.update!(status: new_status)
  end

  def send_rejection_notification
    # Assuming NotificationJob or UserNotifierMailer exists and is configured
    if content_type == 'Question'
      question = Question.find_by(id: content_id)
      UserNotifierMailer.notify_rejection(question.user_id, question.id).deliver_later if question
    elsif content_type == 'Answer'
      answer = Answer.find_by(id: content_id)
      UserNotifierMailer.notify_rejection(answer.question.user_id, answer.id).deliver_later if answer
    end
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
