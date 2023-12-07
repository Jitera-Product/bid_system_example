# FILE PATH: /app/services/chat_channel_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChatChannelService::Index
  include Pundit::Authorization

  def create_chat_channel(user_id, bid_item_id)
    ActiveRecord::Base.transaction do
      user = User.find_by(id: user_id)
      raise Exceptions::AuthenticationError, 'User must be logged in.' unless user&.confirmed_at

      bid_item = BidItem.find_by(id: bid_item_id)
      raise ActiveRecord::RecordNotFound, 'Bid item not found.' unless bid_item

      unless bid_item.chat_enabled
        raise Exceptions::AuthenticationError, 'Can not create a channel for this item.'
      end

      if bid_item.status == 'done' # Assuming 'done' is a valid status
        raise Exceptions::AuthenticationError, 'Bid item already done.'
      end

      chat_channel = ChatChannel.create!(
        bid_item_id: bid_item.id,
        created_at: Time.current,
        updated_at: Time.current
      )

      chat_channel.id
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::ValidationError, e.record.errors.full_messages.to_sentence
  rescue Exceptions::AuthenticationError => e
    raise
  rescue => e
    raise Exceptions::StandardError, 'Failed to create chat channel.'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
