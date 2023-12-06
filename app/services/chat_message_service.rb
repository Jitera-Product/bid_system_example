# /app/services/chat_message_service.rb

class ChatMessageService
  include ActiveModel::Model

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
    raise 'Message limit reached for this chat channel' if message_count >= 500

    # Create a new chat message record
    chat_message = ChatMessage.create!(user_id: user_id, chat_channel_id: chat_channel_id, message: message, created_at: Time.current, updated_at: Time.current)

    # Return a confirmation with the message ID
    ChatMessageSerializer.new(chat_message).as_json
  end

  # Existing code below...
end
