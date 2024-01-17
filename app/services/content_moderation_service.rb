# frozen_string_literal: true

class ContentModerationService
  def self.moderate(content_id, content_type, action, admin_id)
    content = find_content(content_id, content_type)
    content.moderate!(action)
  end

  def self.find_content(content_id, content_type)
    case content_type.downcase
    when 'question'
      Question.find(content_id)
    when 'answer'
      Answer.find(content_id)
    else
      raise Exceptions::ContentNotFound
    end
  end
end
