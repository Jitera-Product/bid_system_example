class CreateBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_items do |t|
      t.decimal :base_price, null: false
      t.string :name, null: false
      t.datetime :expiration_time, null: false
      t.references :product, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
