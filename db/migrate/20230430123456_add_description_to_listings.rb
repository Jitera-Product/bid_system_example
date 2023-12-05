class AddDescriptionToListings < ActiveRecord::Migration[6.0]
  def change
    # Add the description column to the listings table
    add_column :listings, :description, :text, null: true
  end
end
