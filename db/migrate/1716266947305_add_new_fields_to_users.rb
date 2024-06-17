class AddNewFieldsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :confirmed_at, :datetime
    add_column :users, :unlock_token, :string
    add_column :users, :unconfirmed_email, :string
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :remember_created_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :confirmation_token, :string
    add_column :users, :password, :string
    add_column :users, :password_confirmation, :string
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :locked_at, :datetime
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :email, :string, default: '', null: false
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :reset_password_token, :string
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :encrypted_password, :string, default: '', null: false
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :created_at, :datetime, null: false
    add_column :users, :updated_at, :datetime, null: false

    add_index :users, :unlock_token, unique: true
    add_index :users, :unconfirmed_email, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end

  def down
    remove_index :users, :unlock_token
    remove_index :users, :unconfirmed_email
    remove_index :users, :confirmation_token
    remove_index :users, :email
    remove_index :users, :reset_password_token

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