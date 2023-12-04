class AddKycStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :kyc_status, :integer, default: 0, null: false
  end
end
