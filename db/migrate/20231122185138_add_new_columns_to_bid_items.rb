class AddNewColumnsToBidItems < ActiveRecord::Migration[7.0]
  def change
    change_table :bid_items do |t|
      t.change :base_price, :decimal, precision: 10, scale: 2
      t.change :name, :string
      t.change :expiration_time, :datetime
      t.change :status, :string
      t.change :created_at, :datetime, null: false
      t.change :updated_at, :datetime, null: false
      t.change :product_id, :bigint, foreign_key: true
      t.change :user_id, :bigint, foreign_key: true
      t.index :product_id
      t.index :user_id
    end
  end
end
