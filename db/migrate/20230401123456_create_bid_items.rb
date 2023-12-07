class CreateBidItems < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_items do |t|
      t.decimal :base_price, precision: 10, scale: 2, null: false
      t.string :name, null: false
      t.datetime :expiration_time, null: false
      t.integer :status, default: 0, null: false
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :chat_enabled, default: false, null: false
      t.references :bid, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end