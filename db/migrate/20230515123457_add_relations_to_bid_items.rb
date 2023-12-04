class AddRelationsToBidItems < ActiveRecord::Migration[6.0]
  def change
    # Add bid_item reference to listings table
    add_reference :listings, :bid_item, foreign_key: true unless foreign_key_exists?(:listings, :bid_item)

    # Add bid_item reference to bids table
    add_reference :bids, :bid_item, foreign_key: true unless foreign_key_exists?(:bids, :bid_item)
  end
end
