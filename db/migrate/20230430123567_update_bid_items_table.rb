class UpdateBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    # Add new columns to the bid_items table
    add_column :bid_items, :base_price, :decimal, null: false
    add_column :bid_items, :name, :string, null: false
    add_column :bid_items, :expiration_time, :datetime, null: false
    add_column :bid_items, :status, :string, null: false

    # Add an index to the user_id column for better query performance
    add_index :bid_items, :user_id

    # Since the product_id and user_id columns are already added by previous migrations,
    # we do not need to add them again. We just ensure that the indexes are present.
    unless index_exists?(:bid_items, :product_id)
      add_index :bid_items, :product_id
    end
  end
end
