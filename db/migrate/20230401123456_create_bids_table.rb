class CreateBidsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :bids do |t|
      t.integer :status
      t.references :item, null: false, foreign_key: { to_table: :bid_items }
      t.decimal :price, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
