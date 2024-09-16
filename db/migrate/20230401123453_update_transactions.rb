class UpdateTransactions < ActiveRecord::Migration[7.0]
  def change
    change_table :transactions do |t|
      t.change :reference_id, :bigint
      t.change :value, :decimal, precision: 10, scale: 2
      t.change :status, :integer, using: 'status::integer'
      t.change :transaction_type, :integer, using: 'transaction_type::integer'
      t.change :reference_type, :integer, using: 'reference_type::integer'

      # Add index if needed
      unless index_exists?(:transactions, :reference_id)
        add_index :transactions, :reference_id
      end

      # Add foreign key if needed
      # add_foreign_key :transactions, :wallets, column: :wallet_id
    end
  end
end
