class UpdateBidsTable < ActiveRecord::Migration[6.0]
  def change
    # Add bid_item_id reference to bids table
    add_reference :bids, :bid_item, foreign_key: true

    # Rename item_id to bid_item_id for clarity
    rename_column :bids, :item_id, :bid_item_id

    # Add status column to bids table with default value 'new'
    add_column :bids, :status, :string, null: false, default: 'new'
  end
end
