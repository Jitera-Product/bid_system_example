# /app/services/chat_channel_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChatChannelService::Index
  include Pundit::Authorization

  attr_accessor :params, :current_user

  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user
  end

  def create(user_id, bid_item_id)
    validate_user(user_id)
    bid_item = validate_bid_item(bid_item_id)

    chat_channel = ChatChannel.create!(
      user_id: user_id,
      bid_item_id: bid_item_id,
      created_at: Time.current,
      updated_at: Time.current
    )

    { channel_id: chat_channel.id, created_at: chat_channel.created_at }
  end

  # New method to check chat feature status
  def check_chat_feature_status(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise ActiveRecord::RecordNotFound, 'Bid item not found' unless bid_item

    bid_item.chat_enabled ? 'enabled' : 'disabled'
  end

  # New method added as per the requirement
  def fetch_messages(chat_channel_id)
    chat_channel = ChatChannel.find(chat_channel_id)
    chat_messages = chat_channel.chat_messages.select(:id, :message, :user_id, :created_at, :updated_at)
    chat_messages.map do |message|
      {
        id: message.id, # Added id as per the requirement
        content: message.message,
        user_id: message.user_id,
        created_at: message.created_at,
        updated_at: message.updated_at
      }
    end
  rescue ActiveRecord::RecordNotFound
    raise ActiveRecord::RecordNotFound, 'Chat channel not found'
  end

  private

  def validate_user(user_id)
    user = User.find(user_id)
    raise Pundit::NotAuthorizedError, 'User not found or not logged in' unless user && user == @current_user
  end

  def validate_bid_item(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise ActiveRecord::RecordNotFound, 'Bid item not found' unless bid_item
    raise Pundit::NotAuthorizedError, 'Can not create a channel for this item.' unless bid_item.chat_enabled
    raise Pundit::NotAuthorizedError, 'Bid item already done.' if bid_item.status == 'done'

    bid_item
  end
end
# rubocop:enable Style/ClassAndModuleChildren
