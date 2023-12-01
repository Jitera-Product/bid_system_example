class MessagesService
  MAX_MESSAGES = 200
  MAX_CONTENT_LENGTH = 200
  def send_message(chat_channel_id, content)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise Exceptions::ChatChannelNotFound, 'Chat channel not found' unless chat_channel
    raise Exceptions::ChatChannelClosed, 'Chat channel is closed' if chat_channel.is_closed
    raise Exceptions::MessageLimitReached, 'Message limit reached' if chat_channel.messages.count >= MAX_MESSAGES
    raise Exceptions::ContentTooLong, 'Content too long' if content.length > MAX_CONTENT_LENGTH
    message = Message.create(chat_channel_id: chat_channel_id, content: content, created_at: Time.now)
    message.id
  end
end
