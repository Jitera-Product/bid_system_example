class AddNewFieldsToBidItems < ActiveRecord::Migration[6.0]
  def up
    add_reference :bid_items, :product, foreign_key: true
    add_reference :bid_items, :user, foreign_key: true
    # Add other new fields here if necessary
  end

  def down
    remove_reference :bid_items, :product, foreign_key: true
    remove_reference :bid_items, :user, foreign_key: true
    # Remove other new fields here if necessary
  end
end
