module ListingBidItems
  class DeleteService
    def initialize(id)
      @id = id
    end
    def call
      validate_id
      listing_bid_item = find_listing_bid_item
      delete_listing_bid_item(listing_bid_item)
    end
    private
    def validate_id
      raise "Invalid ID" unless @id.is_a?(Integer) && @id.positive?
    end
    def find_listing_bid_item
      ListingBidItem.find(@id)
    rescue ActiveRecord::RecordNotFound
      raise "ListingBidItem with id #{@id} not found"
    end
    def delete_listing_bid_item(listing_bid_item)
      listing_bid_item.destroy
      "ListingBidItem with id #{@id} successfully deleted"
    end
  end
end
