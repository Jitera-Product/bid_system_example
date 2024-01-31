class AddDeletedAtToWallets < ActiveRecord::Migration[6.0]
  def change
    add_column :wallets, :deleted_at, :datetime
    add_index :wallets, :deleted_at
  end
end
