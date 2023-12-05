class AddStatusToBids < ActiveRecord::Migration[6.0]
  def change
    add_column :bids, :status, :integer, null: false, default: 0
    add_index :bids, :status
  end
end
