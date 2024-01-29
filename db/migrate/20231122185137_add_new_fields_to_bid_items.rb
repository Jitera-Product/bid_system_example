class AddNewFieldsToBidItems < ActiveRecord::Migration[7.0]
  def change
    change_table :bid_items do |t|
      t.change :base_price, :decimal, precision: 10, scale: 2, null: false
      t.change :name, :string, null: false
      t.change :expiration_time, :datetime, null: false
      t.change :status, :string, null: false

      # Add foreign key for product_id and user_id if not exists
      unless foreign_key_exists?(:bid_items, :products)
        t.foreign_key :products, column: :product_id
      end
      unless foreign_key_exists?(:bid_items, :users)
        t.foreign_key :users, column: :user_id
      end
    end
  end
end
