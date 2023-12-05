class AddListingBidItemsRelationToListings < ActiveRecord::Migration[6.0]
  def change
    # Add reference for the one-to-many relationship between listings and listing_bid_items
    add_reference :listing_bid_items, :listing, null: false, foreign_key: true
  end
end
