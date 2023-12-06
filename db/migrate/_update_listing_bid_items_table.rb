class UpdateListingBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    # Assuming the column 'up_vote' needs to be added to the 'listing_bid_items' table
    add_column :listing_bid_items, :up_vote, :integer, null: true

    # Assuming 'up_vote' should have a default value of 0
    change_column_default :listing_bid_items, :up_vote, from: nil, to: 0

    # Add foreign key constraints to ensure data integrity
    add_foreign_key :listing_bid_items, :bid_items, column: :bid_item_id
    add_foreign_key :listing_bid_items, :listings, column: :listing_id

    # Add indexes to improve query performance
    add_index :listing_bid_items, :bid_item_id
    add_index :listing_bid_items, :listing_id
  end
end
