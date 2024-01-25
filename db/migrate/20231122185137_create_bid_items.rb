class CreateBidItems < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_items do |t|
      t.decimal :base_price, null: false
      t.string :name, null: false
      t.datetime :expiration_time, null: false
      t.string :status, null: false

      t.timestamps null: false
    end

    add_reference :bid_items, :product, foreign_key: true, null: false, index: true
    add_reference :bid_items, :user, foreign_key: true, null: false, index: true
  end
end


