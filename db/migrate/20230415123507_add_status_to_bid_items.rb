class AddStatusToBidItems < ActiveRecord::Migration[6.0]
  def change
    add_column :bid_items, :status, :string
  end
end
