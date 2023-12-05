class AddListingIdToListingBidItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :listing_bid_items, :listing, foreign_key: true
  end
end
