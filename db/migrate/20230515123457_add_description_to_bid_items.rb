class AddDescriptionToBidItems < ActiveRecord::Migration[6.0]
  def change
    # Check if the column already exists before trying to add it
    unless column_exists?(:bid_items, :description)
      add_column :bid_items, :description, :text, null: false
    end
  end

  # Define the down method to handle rollback
  def down
    remove_column :bid_items, :description if column_exists?(:bid_items, :description)
  end
end
