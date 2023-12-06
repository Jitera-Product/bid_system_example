class CreateBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_items do |t|
      t.decimal :base_price, null: false, precision: 10, scale: 2
      t.string :name, null: false
      t.datetime :expiration_time, null: false
      t.boolean :is_chat_enabled, default: false
      t.integer :status, null: false, default: 0

      t.timestamps null: false
    end

    add_reference :bid_items, :product, foreign_key: true
    add_reference :bid_items, :user, foreign_key: true
  end
end
