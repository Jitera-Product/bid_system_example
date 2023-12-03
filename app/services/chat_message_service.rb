# /app/services/chat_message_service.rb
class ChatMessageService
  include AuthenticationConcern
  include ErrorHandling
  # Existing methods...
  def create_chat_message(chat_channel_id, sender_id, content)
    validate_user_authentication(sender_id)
    chat_channel = ChatChannel.find(chat_channel_id)
    raise StandardError.new('Chat is closed') unless chat_channel.is_active
    message_count = Message.where(chat_channel_id: chat_channel_id).count
    raise StandardError.new('Message limit has been reached') if message_count >= 200
    validate_message_content(content)
    message = Message.create!(
      chat_channel_id: chat_channel_id,
      user_id: sender_id,
      content: content,
      created_at: Time.current
    )
    serialize_message(message)
  rescue StandardError => e
    handle_error(e)
  end
  private
  def validate_user_authentication(user_id)
    # Assuming the AuthenticationConcern provides a method `authenticated?`
    raise StandardError.new('User must be logged in') unless authenticated?(user_id)
  end
  def validate_message_content(content)
    # Assuming the ChatMessageValidator provides a method `validate_content`
    raise StandardError.new('Content length must be 200 characters or less') if content.length > 200
    ChatMessageValidator.validate_content(content)
  end
  def serialize_message(message)
    # Assuming the ChatMessageSerializer provides a method `serialize`
    ChatMessageSerializer.serialize(message).slice(:id, :chat_channel_id, :user_id, :content, :created_at)
  end
end
