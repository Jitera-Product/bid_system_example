# /app/services/bid_item_service.rb

class BidItemService
  # Existing methods...

  # New method to check chat status
  # This method is redundant and will be removed as the new method covers its functionality
  # def self.check_chat_status(bid_item_id)
  #   begin
  #     bid_item = BidItem.find(bid_item_id)
  #     bid_item.chat_enabled
  #   rescue ActiveRecord::RecordNotFound => e
  #     Rails.logger.error "BidItem not found: #{e.message}"
  #     raise
  #   rescue StandardError => e
  #     Rails.logger.error "An error occurred while checking chat status: #{e.message}"
  #     raise
  #   end
  # end

  # New method to check chat feature status
  def self.check_chat_feature_status(bid_item_id)
    begin
      bid_item = BidItem.find_by(id: bid_item_id)
      return { error: "BidItem not found", status: 404 } if bid_item.nil?

      if bid_item.chat_enabled
        { message: "Chat feature is enabled for this item.", status: 200 }
      else
        { error: "Chat feature is not enabled for this item.", status: 400 }
      end
    rescue StandardError => e
      Rails.logger.error "An error occurred while checking chat feature status: #{e.message}"
      { error: e.message, status: 500 }
    end
  end

  # Rest of the existing methods...
end
