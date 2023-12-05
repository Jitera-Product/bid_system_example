class UpdateListingsTable < ActiveRecord::Migration[6.0]
  def change
    # Add new columns to the listings table
    add_column :listings, :title, :string, null: false, default: ''
    add_column :listings, :price, :integer, null: false
    add_column :listings, :quantity, :integer, null: false, default: 1
    add_column :listings, :status, :integer, null: false, default: 0

    # Add an index to the status column for better query performance
    add_index :listings, :status
  end
end
