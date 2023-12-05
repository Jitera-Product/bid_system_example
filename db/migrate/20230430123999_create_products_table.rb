class CreateProductsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.decimal :price, null: false
      t.text :description
      t.string :name, null: false
      t.integer :stock, null: false, default: 0
      t.references :admin, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
