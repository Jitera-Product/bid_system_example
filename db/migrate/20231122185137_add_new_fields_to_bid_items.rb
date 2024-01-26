class AddNewFieldsToBidItems < ActiveRecord::Migration[6.0]
  def up
    add_column :bid_items, :product_id, :integer, index: true
    add_column :bid_items, :user_id, :integer, index: true
    add_foreign_key :bid_items, :products
    add_foreign_key :bid_items, :users
  end

  def down
    remove_foreign_key :bid_items, :products
    remove_foreign_key :bid_items, :users
    remove_column :bid_items, :product_id
    remove_column :bid_items, :user_id
  end
end
