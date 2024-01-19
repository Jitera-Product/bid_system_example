
class ModerationService < BaseService
  def moderate_content(content_id, content_type, status, admin_id, reason = nil)
    content = ModerationQueue.find_by(id: content_id, content_type: content_type)
    return 'Content not found' unless content

    content.update_status(status, reason)

    if content_type == 'Answer' && status == 'approved'
      answer = Answer.find(content_id)
      answer.update_approval(true)
    elsif content_type == 'Question'
      question = Question.find(content_id)
      question.update_based_on_moderation(status, reason)
    end

    'Content moderation completed successfully.'
  end
end
