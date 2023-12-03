class ChatChannelService
  # Add any other existing methods here
  def initialize(*_args)
    super
  end
  def create_chat_channel(user_id, bid_item_id)
    begin
      # Validate that the user_id corresponds to a logged-in user
      unless UserService.logged_in?(user_id)
        raise StandardError.new("User must be logged in to create a chat channel.")
      end
      # Check if the bid_item_id exists and retrieve the associated owner_id
      bid_item = BidItemService.find_bid_item(bid_item_id)
      raise StandardError.new("Bid item not found.") unless bid_item
      # Verify that the is_paid status of the BidItem is false
      if bid_item.is_paid
        raise StandardError.new("Cannot create chat channel for a paid bid item.")
      end
      # Authorize the creation of the chat channel
      unless ChatChannelPolicy.new(user_id, bid_item).authorize_create?
        raise StandardError.new("User is not authorized to create a chat channel for this bid item.")
      end
      # Create a new ChatChannel
      chat_channel = ChatChannel.new(
        user_id: user_id,
        owner_id: bid_item.user_id,
        bid_item_id: bid_item_id,
        is_active: true
      )
      # Save the new ChatChannel
      if chat_channel.save
        # Return the newly created chat channel's ID and is_active status to the user
        return { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
      else
        raise StandardError.new("Failed to create chat channel.")
      end
    rescue StandardError => e
      logger.error "ChatChannelService#create_chat_channel Error: #{e.message}"
      raise
    end
  end
  def close_chat_request(chat_channel_id, owner_id)
    begin
      # Validate that the "owner_id" corresponds to a logged-in user.
      raise StandardError.new('User not logged in') unless UserService.logged_in?(owner_id)
      # Fetch the ChatChannel using the "chat_channel_id" and check if it exists.
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      raise StandardError.new('Chat channel not found') unless chat_channel
      # Check if the logged-in user is the owner of the BidItem associated with the chat channel.
      raise StandardError.new('User not authorized') unless ChatChannelPolicy.owner?(owner_id, chat_channel.bid_item_id)
      # Update the "is_active" attribute to false for the given "chat_channel_id".
      chat_channel.update!(is_active: false)
      # Return confirmation that the chat request has been closed.
      { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
    rescue ActiveRecord::RecordNotFound => e
      raise StandardError.new(e.message)
    rescue StandardError => e
      # Handle exceptions using `StandardError`
      { error: e.message }
    end
  end
end
