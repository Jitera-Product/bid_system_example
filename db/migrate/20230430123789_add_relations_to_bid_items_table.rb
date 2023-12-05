class AddRelationsToBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    # Add foreign key for product_id in bid_items table
    unless foreign_key_exists?(:bid_items, :products)
      add_foreign_key :bid_items, :products, column: :product_id
    end

    # Add foreign key for user_id in bid_items table
    unless foreign_key_exists?(:bid_items, :users)
      add_foreign_key :bid_items, :users, column: :user_id
    end

    # Create listing_bid_items table to handle the one-to-many relationship
    unless table_exists?(:listing_bid_items)
      create_table :listing_bid_items do |t|
        t.references :bid_item, null: false, foreign_key: true, index: true
        t.timestamps
      end
    end

    # Create bids table to handle the one-to-many relationship
    unless table_exists?(:bids)
      create_table :bids do |t|
        t.references :bid_item, null: false, foreign_key: true, index: true
        t.timestamps
      end
    end
  end
end
