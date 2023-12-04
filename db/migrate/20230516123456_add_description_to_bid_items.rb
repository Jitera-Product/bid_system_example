class AddDescriptionToBidItems < ActiveRecord::Migration[6.0]
  def change
    add_column :bid_items, :description, :text, null: false
  end
end
