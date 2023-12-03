# PATH: /app/services/chat_channel_service/create.rb
module ChatChannelService
  class Create
    def self.create(user_id, bid_item_id)
      # Validate the user
      raise 'Invalid user' unless ValidateUser.call(user_id)
      # Validate the bid item and retrieve owner_id
      bid_item, owner_id = ValidateBidItem.call(bid_item_id)
      raise 'Bid item does not exist' if bid_item.nil?
      raise 'Bid item is already paid' if bid_item.is_paid
      # Check if an active chat channel already exists
      existing_channel = CheckExistingChannel.call(user_id, owner_id, bid_item_id)
      raise 'Chat channel already exists' if existing_channel
      # Create a new chat channel
      chat_channel = CreateChannel.call(user_id, owner_id, bid_item_id, true) # Set is_active to true
      # Return the response with the new chat channel's ID
      Response.call(chat_channel.id)
    end
  end
end
