class AddStatusToBids < ActiveRecord::Migration[6.0]
  def change
    add_column :bids, :status, :string, default: 'new'
  end
end
