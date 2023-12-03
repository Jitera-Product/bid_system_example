class CreateBidItemsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_items do |t|
      t.decimal :base_price, precision: 10, scale: 2
      t.string :name
      t.datetime :expiration_time
      t.integer :status
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.boolean :is_paid, default: false

      t.timestamps null: false
    end
  end
end
