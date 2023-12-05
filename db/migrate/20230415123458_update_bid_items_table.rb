class UpdateBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    # Add a new column 'status' to the bid_items table with default value 'active'
    add_column :bid_items, :status, :string, null: false, default: 'active'
  end
end
