# /app/interactors/bid_items/lock_bid_item.rb
module Exceptions
  class NotAuthorizedError < StandardError; end
  class InvalidOperationError < StandardError; end
  class BidItemAlreadyCompletedError < StandardError; end # Added custom exception
end

class LockBidItem
  def initialize(user_id:, bid_item_id:)
    @user_id = user_id
    @bid_item_id = bid_item_id
  end

  def call
    bid_item = BidItem.find(@bid_item_id)

    raise Exceptions::NotAuthorizedError unless bid_item.user_id == @user_id

    # Added condition to check if the bid item's status is 'completed'
    if bid_item.status == 'completed'
      raise Exceptions::BidItemAlreadyCompletedError, 'Bid item is already completed and cannot be locked.'
    end

    if bid_item.status == 'closed'
      raise Exceptions::InvalidOperationError, 'Bid item is already closed and cannot be locked.'
    end

    bid_item.status = 'locked'
    bid_item.save!

    "Bid item #{@bid_item_id} has been successfully locked."
  end
end
