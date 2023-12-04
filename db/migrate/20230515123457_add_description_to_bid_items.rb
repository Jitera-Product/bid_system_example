class AddDescriptionToBidItems < ActiveRecord::Migration[6.0]
  def up
    add_column :bid_items, :description, :text
  end

  def down
    remove_column :bid_items, :description
  end
end
