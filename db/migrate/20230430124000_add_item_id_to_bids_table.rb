class AddItemIdToBidsTable < ActiveRecord::Migration[6.0]
  def change
    # Add item_id column to bids table
    add_reference :bids, :item, null: false, foreign_key: true, index: true
  end
end
