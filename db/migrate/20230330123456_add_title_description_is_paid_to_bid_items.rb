class AddTitleDescriptionIsPaidToBidItems < ActiveRecord::Migration[6.0]
  def change
    add_column :bid_items, :title, :string
    add_column :bid_items, :description, :text
    add_column :bid_items, :is_paid, :boolean, default: false
    # Add indexes for new columns if necessary
    # add_index :bid_items, :title, unique: true
  end
end
