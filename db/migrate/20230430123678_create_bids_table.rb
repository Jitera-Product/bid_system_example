class CreateBidsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :bids do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :bid_item, null: false, foreign_key: true, index: true
      t.decimal :price, null: false
      t.string :status, null: false, default: 'new'
      t.timestamps
    end
  end
end
