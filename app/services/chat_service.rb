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
end
# Custom error class for ChatChannel limit reached
class ChatChannelLimitReachedError < StandardError; end
