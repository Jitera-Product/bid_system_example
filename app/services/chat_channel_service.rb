# PATH: /app/services/chat_channel_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChatChannelService::Create
  def execute(bid_item_id, user_id)
    raise 'Wrong format' unless bid_item_id.is_a?(Integer) && user_id.is_a?(Integer)
    bid_item = BidItem.find_by(id: bid_item_id)
    user = User.find_by(id: user_id)
    raise 'This bid item is not found' if bid_item.nil?
    raise 'This user is not found' if user.nil?
    raise 'This bid item is already paid' if bid_item.is_paid
    chat_channel = ChatChannel.create(bid_item_id: bid_item_id, user_id: user_id)
    chat_channel
  end
end
# rubocop:enable Style/ClassAndModuleChildren
