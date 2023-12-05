class AddRelationsToListings < ActiveRecord::Migration[6.0]
  def change
    # Assuming listing_bid_items table and listing_id column already exist
    # If not, you would need to create them as well with create_table and add_reference

    # Add foreign key constraint to listing_bid_items for listing_id
    # This is only necessary if the foreign key constraint was not already set in previous migrations
    add_foreign_key :listing_bid_items, :listings, column: :listing_id
  end
end
