class UpdateDeposits < ActiveRecord::Migration[7.0]
  def change
    change_table :deposits do |t|
      # Update the value column to be a decimal with precision and scale
      t.change :value, :decimal, precision: 10, scale: 2, null: false

      # Update the status column to use integers for the enum
      t.change :status, :integer, default: 0, null: false

      # Add foreign key constraints
      t.foreign_key :payment_methods, column: :payment_method_id
      t.foreign_key :wallets, column: :wallet_id
      t.foreign_key :users, column: :user_id
    end
  end
end
