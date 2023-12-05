# /app/services/bid_item_unlock_service.rb

class BidItemUnlockService
  def unlock_bid_item(user_id:, bid_item_id:)
    bid_item = BidItem.find(bid_item_id)

    raise 'Bid item has expired' if Time.current > bid_item.expiration_time
    raise 'User does not have permission to unlock this bid item' unless bid_item.user_id == user_id
    raise 'Bid item is not locked' unless bid_item.status == 'locked'

    bid_item.status = 'active'
    bid_item.save!

    "Bid item #{bid_item_id} has been successfully unlocked"
  rescue ActiveRecord::RecordNotFound
    "Bid item with id #{bid_item_id} does not exist"
  rescue => e
    e.message
  end
end
