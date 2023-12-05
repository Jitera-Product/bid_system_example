# /app/services/bid_item_lock_service.rb
module Exceptions
  class NotAuthorizedError < StandardError; end
  class InvalidOperationError < StandardError; end
end

class BidItemLockService
  def lock(user_id, bid_item_id)
    bid_item = BidItem.find(bid_item_id)

    # The requirement states that we should verify that the "user_id" from the input does not match the "user_id" associated with the bid item.
    # The original code raises an error if the user_id matches, which is incorrect according to the new requirement.
    # Therefore, we need to invert the condition to match the requirement.
    raise Exceptions::NotAuthorizedError, 'User does not have permission to lock this bid item.' unless bid_item.user_id != user_id

    # The rest of the code remains unchanged as it does not conflict with the new requirement.
    lock_bid_item(user_id: user_id, bid_item_id: bid_item_id)
  end

  private

  def lock_bid_item(user_id:, bid_item_id:)
    bid_item = BidItem.find(bid_item_id)

    # The condition here is also inverted to match the new requirement.
    raise Exceptions::NotAuthorizedError unless bid_item.user_id != user_id

    if bid_item.status == 'closed'
      raise Exceptions::InvalidOperationError, 'Bid item is already closed and cannot be locked.'
    end

    bid_item.status = 'locked'
    bid_item.save!

    "Bid item #{bid_item_id} has been successfully locked."
  end
end
