# /app/services/chat_channel_service.rb
class ChatChannelService
  # Add any other existing methods here
  def close_chat_request(chat_channel_id, owner_id)
    begin
      # Validate that the "owner_id" corresponds to a logged-in user.
      raise CustomException.new('User not logged in') unless UserService.logged_in?(owner_id)
      # Fetch the ChatChannel using the "chat_channel_id" and check if it exists.
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      raise CustomException.new('Chat channel not found') unless chat_channel
      # Check if the logged-in user is the owner of the BidItem associated with the chat channel.
      raise CustomException.new('User not authorized') unless ChatChannelPolicy.owner?(owner_id, chat_channel.bid_item_id)
      # Update the "is_active" attribute to false for the given "chat_channel_id".
      chat_channel.update!(is_active: false)
      # Return confirmation that the chat request has been closed.
      { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
    rescue ActiveRecord::RecordNotFound => e
      raise CustomException.new(e.message)
    rescue CustomException => e
      # Handle exceptions using `CustomException`
      { error: e.message }
    end
  end
end
