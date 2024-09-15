class AddPaymentGatewayNameToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :payment_gateway_name, :string
  end
end


