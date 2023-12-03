# /app/services/chat_message_service.rb

class ChatMessageService
  include AuthenticationConcern
  include ChatChannelValidator
  include MessageContentValidator
  include MessageCountValidator

  def create_chat_message(chat_channel_id, sender_id, content)
    # Authenticate the sender
    authenticate_user!(sender_id)

    # Retrieve the chat channel and validate it
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    validate_chat_channel!(chat_channel)

    # Validate the message content length
    validate_message_content!(content)

    # Validate the number of messages in the chat channel
    validate_message_count!(chat_channel)

    # Create the message
    message = Message.create!(
      chat_channel_id: chat_channel_id,
      user_id: sender_id,
      content: content,
      created_at: Time.current
    )

    # Serialize the message for the response
    serialized_message = ChatMessageSerializer.new(message).serialize

    { success: true, message: serialized_message }
  end

  private

  def authenticate_user!(user_id)
    # Assuming AuthenticationConcern provides a method to check if the user is logged in
    # and the logged-in user's ID matches the provided user_id
    unless logged_in? && current_user.id == user_id
      raise AuthenticationError, 'User must be logged in and the sender must match the logged-in user'
    end
  end

  def validate_chat_channel!(chat_channel)
    # Assuming ChatChannelValidator provides a method to check if the chat channel is active
    unless chat_channel && chat_channel.is_active
      raise ValidationError, 'Chat channel must exist and be active'
    end
  end

  def validate_message_content!(content)
    # Assuming MessageContentValidator provides a method to check the content length
    unless content.length <= 200
      raise ValidationError, 'Message content must not exceed 200 characters'
    end
  end

  def validate_message_count!(chat_channel)
    # Assuming MessageCountValidator provides a method to check the number of messages
    unless chat_channel.messages.count < 200
      raise ValidationError, 'Chat channel must not exceed 200 messages'
    end
  end
end
