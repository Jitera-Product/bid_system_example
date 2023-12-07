# /app/services/chat_service/index.rb

class ChatService
  # Add the new method send_chat_message according to the guidelines
  def self.send_chat_message(user_id, chat_channel_id, content)
    # Validate that "user_id" corresponds to a logged-in user
    return { success: false, message: 'User must be logged in.' } unless User.find(user_id).signed_in?

    # Ensure the "content" does not exceed 256 characters. If it does, truncate the message.
    content = content[0...256] if content.length > 256

    # Fetch the "chat_channel" using "chat_channel_id"
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise Exceptions::ChatChannelError, 'Chat channel does not exist or is not active.' if chat_channel.nil? || !chat_channel.bid_item.active?

    # Check the number of messages in the "chat_messages" table for the given "chat_channel_id"
    if ChatMessage.where(chat_channel_id: chat_channel_id).count > 500
      raise Exceptions::ChatMessageLimitError, 'Message limit exceeded for this chat channel.'
    end

    # Create a new record in the "chat_messages" table
    chat_message = ChatMessage.create!(
      chat_channel_id: chat_channel_id,
      user_id: user_id,
      content: content,
      created_at: Time.current,
      updated_at: Time.current
    )

    # Return a confirmation message along with the message ID
    { success: true, message: 'Chat message sent successfully.', message_id: chat_message.id }
  rescue Exceptions::ChatMessageError => e
    { success: false, message: e.message }
  rescue Exceptions::ChatChannelError => e
    { success: false, message: e.message }
  rescue Exceptions::ChatMessageLimitError => e
    { success: false, message: e.message }
  rescue => e
    { success: false, message: e.message }
  end
end
