# /app/services/bid_item_lock_service.rb
module Exceptions
  class NotAuthorizedError < StandardError; end
  class InvalidOperationError < StandardError; end
end

class BidItemLockService
  def lock_bid_item(user_id:, bid_item_id:)
    bid_item = BidItem.find(bid_item_id)

    raise Exceptions::NotAuthorizedError unless bid_item.user_id == user_id

    if bid_item.status == 'closed'
      raise Exceptions::InvalidOperationError, 'Bid item is already closed and cannot be locked.'
    end

    bid_item.status = 'locked'
    bid_item.save!

    "Bid item #{bid_item_id} has been successfully locked."
  end
end
