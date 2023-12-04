class ListingBidItems::CreateService < BaseService
  attr_accessor :listing_id, :bid_id
  def initialize(listing_id, bid_id)
    @listing_id = listing_id
    @bid_id = bid_id
  end
  def call
    validate_input
    listing = Listing.find_by_id(listing_id)
    bid = Bid.find_by_id(bid_id)
    raise Exceptions::NotFoundError, 'Listing not found' unless listing
    raise Exceptions::NotFoundError, 'Bid not found' unless bid
    listing_bid_item = ListingBidItem.create(listing_id: listing_id, bid_id: bid_id)
    listing_bid_item.as_json
  rescue => e
    handle_exception(e)
  end
  private
  def validate_input
    raise Exceptions::InvalidParameterError, 'Invalid listing_id' unless listing_id.is_a?(Integer)
    raise Exceptions::InvalidParameterError, 'Invalid bid_id' unless bid_id.is_a?(Integer)
  end
end
