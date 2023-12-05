class CreateListingsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.text :description
      t.timestamps
    end

    # Add references to other tables
    # Assuming the listing_bid_items table exists and has a listing_id column
    add_reference :listing_bid_items, :listing, foreign_key: true, index: true
  end
end
