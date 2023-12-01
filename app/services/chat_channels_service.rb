class ChatChannelsService
  MAX_MESSAGES = 200
  MAX_CONTENT_LENGTH = 200
  def send_message(chat_channel_id, content)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    return { error: 'Chat channel does not exist' } unless chat_channel
    return { error: 'Chat channel is closed' } if chat_channel.is_closed
    return { error: 'Message limit reached' } if chat_channel.messages.count >= MAX_MESSAGES
    return { error: 'Content exceeds limit' } if content.length > MAX_CONTENT_LENGTH
    message = Message.create(chat_channel_id: chat_channel_id, content: content, created_at: Time.now)
    { message_id: message.id }
  end
end
