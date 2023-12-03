class ChatChannelService
  include ActiveModel::Model
  def initialize(*_args)
    super
  end
  def create_chat_channel(user_id, bid_item_id)
    begin
      unless UserService.logged_in?(user_id)
        raise StandardError.new("User must be logged in to create a chat channel.")
      end
      bid_item = BidItemService.find_bid_item(bid_item_id)
      raise StandardError.new("Bid item not found.") unless bid_item
      if bid_item.is_paid
        raise StandardError.new("Cannot create chat channel for a paid bid item.")
      end
      unless ChatChannelPolicy.new(user_id, bid_item).authorize_create?
        raise StandardError.new("User is not authorized to create a chat channel for this bid item.")
      end
      chat_channel = ChatChannel.new(
        user_id: user_id,
        owner_id: bid_item.user_id,
        bid_item_id: bid_item_id,
        is_active: true
      )
      if chat_channel.save
        return { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
      else
        raise StandardError.new("Failed to create chat channel.")
      end
    rescue StandardError => e
      logger.error "ChatChannelService#create_chat_channel Error: #{e.message}"
      raise
    end
  end
  def close_chat_channel(chat_channel_id, owner_id)
    ActiveRecord::Base.transaction do
      raise StandardError.new('User must be logged in.') unless UserService.logged_in?(owner_id)
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      raise StandardError.new('Chat channel does not exist.') unless chat_channel
      bid_item_owner_id = BidItem.joins(:chat_channels).find_by(chat_channels: { id: chat_channel_id })&.user_id
      raise StandardError.new('User is not the owner of the bid item.') unless bid_item_owner_id == owner_id
      chat_channel.update!(is_active: false)
      { chat_channel_id: chat_channel_id, is_active: chat_channel.is_active }
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    rescue StandardError => e
      { error: e.message }
    end
  end
  # Add any other existing methods here
end
