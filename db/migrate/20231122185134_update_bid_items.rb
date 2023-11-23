class UpdateBidItems < ActiveRecord::Migration[6.0]
  def change
    change_table :bid_items do |t|
      t.integer :base_price, null: false
      t.string :name, null: false, default: 'Product Name'
      t.datetime :expiration_time, null: false
      t.integer :status, null: false, default: BidItem.statuses['draft']
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
