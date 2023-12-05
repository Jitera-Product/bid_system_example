# PATH /db/migrate/20230430123456_add_foreign_key_to_listing_bid_items.rb
class AddForeignKeyToListingBidItems < ActiveRecord::Migration[6.0]
  def change
    # Add foreign key for listing_id in listing_bid_items table
    unless foreign_key_exists?(:listing_bid_items, :listings)
      add_foreign_key :listing_bid_items, :listings, column: :listing_id
    end
  end
end
