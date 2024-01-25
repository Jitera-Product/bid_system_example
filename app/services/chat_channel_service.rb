class ChatChannelService
  class ChatChannelAlreadyDisabledError < StandardError; end

  def create_chat_channel(bid_item_id:)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise ActiveRecord::RecordNotFound, "Bid item not found" unless bid_item

    if bid_item.active_for_chat?
      chat_channel = ChatChannel.new(bid_item_id: bid_item_id, status: 'active')
      chat_channel.save!
      chat_channel.id
    else
      raise Exceptions::AuthenticationError, "Chat cannot be created for this bid item"
    end
  end

  def disable_chat_channel(bid_item_id:)
    bid_item = BidItem.find_by_id(bid_item_id)
    raise ActiveRecord::RecordNotFound unless bid_item

    chat_channel = bid_item.chat_channels.find_by(bid_item_id: bid_item_id)
    raise ActiveRecord::RecordNotFound unless chat_channel

    raise ChatChannelAlreadyDisabledError if chat_channel.status == 'disabled'

    chat_channel.disable_channel
    "Chat has been disabled"
  end
end
