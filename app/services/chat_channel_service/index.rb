# PATH: /app/services/chat_channel_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
require 'exceptions'
class ChatChannelService::Index
  def create_chat_channel(user_id, bid_item_id)
    validate_user(user_id)
    bid_item = fetch_bid_item(bid_item_id)
    check_bid_item_paid_status(bid_item)
    chat_channel = create_and_save_chat_channel(user_id, bid_item)
    { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
  end
  private
  def validate_user(user_id)
    UserService.new.validate_logged_in_user(user_id)
  end
  def fetch_bid_item(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise Exceptions::RecordNotFound, "BidItem not found" unless bid_item
    bid_item
  end
  def check_bid_item_paid_status(bid_item)
    raise Exceptions::BidItemPaidException, "BidItem is already paid" if bid_item.is_paid
  end
  def create_and_save_chat_channel(user_id, bid_item)
    chat_channel = ChatChannel.new(
      user_id: user_id,
      owner_id: bid_item.owner_id, # Added owner_id from the bid_item as per requirement
      bid_item_id: bid_item.id,
      is_active: true
    )
    chat_channel.save!
    chat_channel
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::ValidationErrors.new(e.record.errors.full_messages)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
