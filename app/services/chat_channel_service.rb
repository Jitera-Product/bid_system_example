# /app/services/chat_channel_service.rb

# Existing code from other services (if any) should remain untouched
# ...

# New service class for creating chat channels
class ChatChannelService::Create
  attr_reader :user_id, :bid_item_id

  def initialize(user_id, bid_item_id)
    @user_id = user_id
    @bid_item_id = bid_item_id
  end

  def call
    # Validate that the user_id corresponds to a logged-in user
    user = User.find_by(id: user_id)
    raise StandardError.new("User must be logged in."), status: 400 unless user.present? && user == current_user

    # Fetch the bid_item to ensure it exists
    bid_item = BidItem.find_by(id: bid_item_id)
    raise StandardError.new("Bid item not found."), status: 400 unless bid_item.present?

    # Check if the chat_enabled field in the bid_item is set to true
    raise StandardError.new("Can not create a channel for this item."), status: 400 unless bid_item.chat_enabled

    # Check if the status field in the bid_item indicates that the bid item is already done
    raise StandardError.new("Bid item already done."), status: 400 if bid_item.status == 'done'

    # Create a new ChatChannel record with the user_id and bid_item_id
    chat_channel = ChatChannel.create!(user_id: user_id, bid_item_id: bid_item_id)

    # Return the ID of the newly created ChatChannel
    chat_channel.id
  end

  private

  # Assuming the current_user method is available in ApplicationController
  # This is a placeholder to mimic the behavior of current_user method
  def current_user
    # This method should be implemented to return the current logged-in user
    # For the purpose of this example, it's left as a placeholder
    raise NotImplementedError
  end
end

# Existing code from other services (if any) should remain untouched
# ...
