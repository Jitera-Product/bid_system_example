# /app/services/bid_item_lock_service.rb
class BidItemLockService
  class CustomError < StandardError; end

  def lock_bid_item(id, user_id)
    bid_item = BidItem.find_by(id: id)
    raise CustomError, 'Bid item does not exist' unless bid_item

    user = User.find_by(id: user_id)
    raise CustomError, 'User does not exist or is not the owner of the bid item' unless user && user.id == bid_item.owner_id # Changed from bid_item.user_id to bid_item.owner_id

    if bid_item.is_locked
      raise CustomError, 'Bid item is already locked'
    else
      BidItem.transaction do
        bid_item.update!(is_locked: true)
      end
      'Bid item has been successfully locked'
    end
  end
end
