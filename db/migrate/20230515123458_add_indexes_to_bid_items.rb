class AddIndexesToBidItems < ActiveRecord::Migration[6.0]
  def change
    # Adding indexes to columns that are frequently used in searches can improve performance
    add_index :bid_items, :name, unique: true
    add_index :bid_items, :expiration_time
    add_index :bid_items, :status
    add_index :bid_items, :is_locked
    add_index :bid_items, :created_at
    add_index :bid_items, :updated_at
  end
end
