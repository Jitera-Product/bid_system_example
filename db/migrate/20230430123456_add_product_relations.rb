class AddProductRelations < ActiveRecord::Migration[6.0]
  def change
    # Add a reference to bid_items table
    create_table :bid_items do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :bid_price
      t.timestamps
    end

    # Add a reference to product_categories table
    create_table :product_categories do |t|
      t.references :product, null: false, foreign_key: true
      t.string :category_name
      t.timestamps
    end

    # Add indexes to the foreign keys for better query performance
    add_index :bid_items, :product_id
    add_index :product_categories, :product_id
  end
end
