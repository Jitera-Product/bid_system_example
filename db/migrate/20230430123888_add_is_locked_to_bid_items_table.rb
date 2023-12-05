class AddIsLockedToBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :bid_items, :is_locked, :boolean, default: false, null: false
  end
end
