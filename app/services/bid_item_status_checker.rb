# /app/services/bid_item_status_checker.rb

class BidItemStatusChecker
  def check_status(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise ActiveRecord::RecordNotFound, 'Bid item not found' unless bid_item

    case bid_item.status
    when 'done'
      'done'
    else
      'active'
    end
  rescue ActiveRecord::RecordNotFound => e
    raise e
  rescue StandardError => e
    raise "An error occurred while checking the bid item status: #{e.message}"
  end
end
