class AddTitleDescriptionIsPaidToBidItems < ActiveRecord::Migration[6.0]
  def change
    add_column :bid_items, :title, :string
    add_column :bid_items, :description, :text
    add_column :bid_items, :is_paid, :boolean, default: false
  end
end
