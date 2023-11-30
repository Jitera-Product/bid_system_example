class UpdateUsersTable < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :role, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :unlock_token, :string
    add_column :users, :unconfirmed_email, :string
    add_column :users, :sign_in_count, :integer
    add_column :users, :remember_created_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :confirmation_token, :string
    add_column :users, :password, :string
    add_column :users, :password_confirmation, :string
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :locked_at, :datetime
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :email, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :reset_password_token, :string
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :encrypted_password, :string
    add_column :users, :failed_attempts, :integer
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
  end
  def down
    remove_column :users, :role
    remove_column :users, :confirmed_at
    remove_column :users, :unlock_token
    remove_column :users, :unconfirmed_email
    remove_column :users, :sign_in_count
    remove_column :users, :remember_created_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :confirmation_token
    remove_column :users, :password
    remove_column :users, :password_confirmation
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    remove_column :users, :locked_at
    remove_column :users, :current_sign_in_at
    remove_column :users, :email
    remove_column :users, :reset_password_sent_at
    remove_column :users, :reset_password_token
    remove_column :users, :confirmation_sent_at
    remove_column :users, :encrypted_password
    remove_column :users, :failed_attempts
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
