# PATH: /app/interactors/create_chat_channel_interactor.rb
module Exceptions
  class ChatNotEnabledError < StandardError; end
  class BidItemDoneError < StandardError; end
  class UnauthorizedError < StandardError; end # Added missing UnauthorizedError exception
end

class CreateChatChannelInteractor
  def initialize(user_id, bid_item_id)
    @user_id = user_id
    @bid_item_id = bid_item_id
  end

  def call
    validate_user
    bid_item = retrieve_bid_item
    validate_bid_item(bid_item)
    create_chat_channel(bid_item)
  end

  private

  def validate_user
    raise Exceptions::UnauthorizedError, "User must be logged in" unless UserService.logged_in?(@user_id) # Added error message
  end

  def retrieve_bid_item
    bid_item = BidItemService.find_bid_item(@bid_item_id)
    raise ActiveRecord::RecordNotFound, "BidItem not found" unless bid_item
    bid_item
  end

  def validate_bid_item(bid_item)
    raise Exceptions::ChatNotEnabledError, "Can not create a channel for this item" unless bid_item.chat_enabled
    raise Exceptions::BidItemDoneError, "Bid item already done" unless bid_item.status == 'active' # Assuming 'active' is the status for active bid items
  end

  def create_chat_channel(bid_item)
    chat_channel = ChatChannel.create!(user_id: @user_id, bid_item_id: bid_item.id, created_at: Time.current, updated_at: Time.current) # Added timestamps
    chat_channel.id
  end
end
