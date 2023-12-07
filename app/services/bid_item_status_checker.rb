# /app/services/bid_item_status_checker.rb

class BidItemStatusChecker
  class BidItemNotFound < StandardError; end

  def self.check_status(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise BidItemNotFound, "Bid item with id #{bid_item_id} not found." unless bid_item

    case bid_item.status
    when 'active'
      'active'
    when 'done'
      'done'
    else
      raise "Unknown status value for bid item with id #{bid_item_id}."
    end
  end
end
