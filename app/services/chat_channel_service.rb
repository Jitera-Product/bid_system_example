# rubocop:disable Style/ClassAndModuleChildren
class ChatChannelService
  include Pundit::Authorization
  include ErrorHandlingConcern
  include AuthenticationConcern
  def initialize(current_user = nil)
    @current_user = current_user
  end
  def create_chat_channel(user_id, bid_item_id)
    begin
      authenticate_user(user_id)
      user = UserService.find_authenticated_user(user_id)
      raise 'User not found or not authenticated' unless user
      bid_item = BidItemService.find_bid_item(bid_item_id)
      raise 'Bid item not found' unless bid_item
      raise 'Cannot create chat channel for a paid item' if bid_item.is_paid
      chat_channel = ChatChannel.create!(
        user_id: user_id,
        owner_id: bid_item.owner_id,
        bid_item_id: bid_item_id,
        is_active: true
      )
      { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
    rescue => e
      handle_standard_error(e)
    end
  end
  def close_channel(chat_channel_id, owner_id)
    authenticate_user(owner_id)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise CustomException.new("Chat channel not found") unless chat_channel
    authorize chat_channel, :close?, policy_class: ChatChannelPolicy
    ActiveRecord::Base.transaction do
      chat_channel.update!(is_active: false)
    end
    { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
  rescue Pundit::NotAuthorizedError => e
    handle_pundit_error(e)
  rescue ActiveRecord::RecordNotFound => e
    handle_active_record_not_found_error(e)
  rescue ActiveRecord::RecordInvalid => e
    raise CustomException.new(e.message)
  rescue StandardError => e
    handle_standard_error(e)
  end
  private
  def authenticate_user(user_id)
    raise CustomException.new("User must be logged in") unless user_authenticated?(user_id)
  end
  def user_authenticated?(user_id)
    @current_user && @current_user.id == user_id
  end
end
# rubocop:enable Style/ClassAndModuleChildren
