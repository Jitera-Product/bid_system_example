class CreateBidItems < ActiveRecord::Migration[7.0]
  def up
    create_table :bid_items do |t|
      t.decimal :base_price, null: false
      t.string :name, null: false
      t.datetime :expiration_time, null: false
      t.integer :status, null: false, default: 0
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :bid_items
  end
end