# /app/services/bid_item_service.rb

class BidItemService
  # Existing methods...

  # New method to check chat status
  def self.check_chat_status(bid_item_id)
    begin
      bid_item = BidItem.find(bid_item_id)
      bid_item.chat_enabled
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "BidItem not found: #{e.message}"
      raise
    rescue StandardError => e
      Rails.logger.error "An error occurred while checking chat status: #{e.message}"
      raise
    end
  end

  # Rest of the existing methods...
end
