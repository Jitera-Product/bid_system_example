# /app/services/chat_message_service.rb

class ChatMessageService
  include ActiveModel::Model
  MAX_MESSAGES_PER_CHANNEL = 500

  # Add new method send_chat_message here
  def send_chat_message(user_id, chat_channel_id, message)
    # Validate that the user is logged in
    raise 'User must be logged in' unless UserService.logged_in?(user_id)

    # Fetch the chat channel and ensure it exists and is associated with the user
    chat_channel = ChatChannel.find_by_id(chat_channel_id)
    raise 'Chat channel does not exist or user is not associated with it' unless chat_channel && chat_channel.user_id == user_id

    # Validate the length of the message
    if message.length > 256
      # Truncate the message to 256 characters if it exceeds the limit
      message = message[0...256]
    end

    # Check the number of messages in the chat channel
    message_count = ChatMessage.where(chat_channel_id: chat_channel_id).count
    raise 'Message limit reached for this chat channel' if message_count >= MAX_MESSAGES_PER_CHANNEL

    # Create a new chat message record
    chat_message = ChatMessage.create!(user_id: user_id, chat_channel_id: chat_channel_id, message: message, created_at: Time.current, updated_at: Time.current)

    # Return a confirmation with the message ID
    ChatMessageSerializer.new(chat_message).as_json
  end

  def check_message_limit(chat_channel_id)
    message_count = ChatMessage.where(chat_channel_id: chat_channel_id).count
    if message_count >= MAX_MESSAGES_PER_CHANNEL
      raise Exceptions::ChatMessageLimitReached, "The message limit for this channel has been reached."
    else
      { message_count: message_count, can_send_more: true }
    end
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::ChatChannelNotFound, "Chat channel not found."
  end

  # Existing code below...
end
