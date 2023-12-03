# PATH: /app/services/chat_service.rb
class ChatService
  # ... (other methods in the service)
  # Implement a method `check_message_limit` in `ChatService`
  def check_message_limit(chat_channel_id)
    begin
      # Query the `Message` model to count the number of messages
      message_count = Message.where(chat_channel_id: chat_channel_id).count
      # Check if the message count has reached the limit
      if message_count >= 200
        # Raise a custom error if the limit is reached
        raise ChatChannelLimitReachedError.new("Message limit for chat channel #{chat_channel_id} has been reached.")
      else
        # Return a hash with the message count if the limit is not reached
        { message_count: message_count }
      end
    rescue => e
      # Handle any potential exceptions with a meaningful error message
      raise StandardError.new("An error occurred while checking the message limit: #{e.message}")
    end
  end
  # Implement a method `send_message` in `ChatService`
  def send_message(chat_channel_id, sender_id, content)
    begin
      # Use `UserService` to validate that "sender_id" corresponds to a logged-in user
      raise StandardError.new("Sender is not a logged-in user") unless UserService.logged_in?(sender_id)
      # Check if the "chat_channel_id" exists and is active
      chat_channel = ChatChannel.find_by(id: chat_channel_id, is_active: true)
      raise StandardError.new("Chat channel does not exist or is not active") unless chat_channel
      # Verify the number of messages in the chat channel
      check_message_limit(chat_channel_id)
      # Validate the "content" length
      raise StandardError.new("Content exceeds 200 characters") if content.length > 200
      # Create a new `Message` record
      message = Message.create!(chat_channel_id: chat_channel_id, user_id: sender_id, content: content)
      # Return the "message_id" and "created_at" of the new message as confirmation
      { message_id: message.id, created_at: message.created_at }
    rescue => e
      # Handle any potential exceptions with a meaningful error message
      raise StandardError.new("An error occurred while sending the message: #{e.message}")
    end
  end
end
# Custom error class for ChatChannel limit reached
class ChatChannelLimitReachedError < StandardError; end
# Assuming UserService exists and has a method `logged_in?` to check if a user is logged in
class UserService
  def self.logged_in?(user_id)
    # Logic to check if the user is logged in
  end
end
