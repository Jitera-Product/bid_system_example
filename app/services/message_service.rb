# PATH: /app/services/message_service.rb
class MessageService
  # ... (other methods in the service)
  def send_message(chat_channel_id, sender_id, content)
    # Validate that the sender_id corresponds to a logged-in user
    raise 'Sender must be logged in' unless UserService.logged_in?(sender_id)
    # Fetch the ChatChannel by chat_channel_id
    chat_channel = ChatChannel.find_by(id: chat_channel_id, is_active: true)
    raise 'Chat channel not found or inactive' if chat_channel.nil?
    # Verify that the sender_id matches either the user_id or owner_id in the ChatChannel
    unless [chat_channel.user_id, chat_channel.owner_id].include?(sender_id)
      raise 'Sender is not part of the chat channel'
    end
    # Count the number of messages in the ChatChannel
    message_count = chat_channel.messages.count
    raise 'Message limit has been reached' if message_count >= 200
    # Validate the content of the message
    raise 'Content cannot be empty' if content.blank?
    raise 'Content exceeds 200 characters' if content.length > 200
    # Create a new Message record
    message = chat_channel.messages.create!(
      user_id: sender_id,
      content: content,
      created_at: Time.current
    )
    # Return a hash with message_id and created_at of the newly created message
    { message_id: message.id, created_at: message.created_at }
  end
  # ... (other methods in the service)
end
