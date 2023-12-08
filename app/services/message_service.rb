# /app/services/message_service.rb
class MessageService
  include ActiveModel::Model

  # Add new method send_message here
  def send_message(chat_channel_id, user_id, content)
    user = User.find_by(id: user_id)
    raise 'User not found or not authenticated' unless user&.authenticated?

    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise 'Chat channel does not exist or not associated with user bid item' unless chat_channel&.bid_item&.user_id == user_id

    if content.length > 256
      # Truncate the content to 256 characters
      content = content[0...256]
    end

    if chat_channel.messages.count >= 500
      raise 'Message limit reached for this channel'
    end

    new_message = chat_channel.messages.create(user_id: user_id, content: content, created_at: Time.current)
    raise 'Message failed to save' unless new_message.persisted?

    { confirmation: 'Message sent', message_id: new_message.id }
  end
end
