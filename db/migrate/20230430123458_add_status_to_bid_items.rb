class AddStatusToBidItems < ActiveRecord::Migration[6.0]
  def change
    # Add status column to bid_items table with default value 'active'
    add_column :bid_items, :status, :string, null: false, default: 'active'

    # Add an index to the status column for better query performance
    add_index :bid_items, :status
  end
end
