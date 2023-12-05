class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :verification_code, :string
    add_column :users, :is_verified, :boolean, default: false
  end
end
