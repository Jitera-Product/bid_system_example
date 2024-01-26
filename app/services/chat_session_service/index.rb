module ChatSessionService
  class Index < BaseService
    def create_chat_session(bid_item_id:, user_id:)
      bid_item = BidItem.find_by(id: bid_item_id)

      raise StandardError.new(I18n.t('chat_sessions.errors.bid_item_not_found')) if bid_item.nil?
      raise StandardError.new(I18n.t('chat_sessions.errors.bid_item_completed')) if bid_item.status_done?

      chat_session_policy = ChatSessionPolicy.new(user_id, bid_item)
      raise StandardError.new(I18n.t('chat_sessions.errors.unauthorized')) unless chat_session_policy.create?

      chat_session = ChatSession.find_or_initialize_by(bid_item_id: bid_item_id, user_id: user_id)

      if chat_session.new_record?
        chat_session.is_active = true
        chat_session.save!
      elsif !chat_session.is_active
        chat_session.update!(is_active: true)
      end

      chat_session
    rescue ActiveRecord::RecordNotFound => e
      raise StandardError.new(e.message)
    rescue ActiveRecord::RecordInvalid => e
      raise StandardError.new(e.record.errors.full_messages.join(', '))
    end
  end
end

class BaseService
  # BaseService code here
end
