class AddTransactionCodeToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_column :deposits, :transaction_code, :string

    reversible do |dir|
      dir.up { }
      dir.down { remove_column :deposits, :transaction_code }
    end
  end
end
