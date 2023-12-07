# /app/services/bid_item_status_validator.rb

class BidItemStatusValidator
  def self.validate_status(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    return { error: 'Bid item not found' } unless bid_item

    if bid_item.status_done?
      raise Exceptions::CustomError.new('Bid item already done.', 400)
    else
      { message: 'Bid item is active and eligible for chat.' }
    end
  end
end
