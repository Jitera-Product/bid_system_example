class ChatChannelService::Close
  def initialize(chat_channel_id, current_user)
    @chat_channel_id = chat_channel_id
    @current_user = current_user
  end
  def close_chat_channel
    raise 'User must be logged in' unless @current_user
    chat_channel = ChatChannel.find_by(id: @chat_channel_id)
    raise 'Chat channel not found' unless chat_channel
    bid_item = BidItem.find_by(id: chat_channel.bid_item_id)
    raise 'User is not the owner of the bid item' unless bid_item.user_id == @current_user.id
    chat_channel.update(is_closed: true)
    { status: 'success', message: 'Chat channel closed successfully' }
  rescue => e
    { status: 'error', message: e.message }
  end
end
