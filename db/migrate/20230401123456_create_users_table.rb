class CreateUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.datetime :reset_password_sent_at
      t.string :reset_password_token
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.integer :failed_attempts, default: 0, null: false
      t.string :unlock_token
      t.datetime :locked_at
      t.string :password
      t.string :password_confirmation
      t.string :username
      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :unconfirmed_email, unique: true
    # Relations
    add_foreign_key :bid_items, :users, column: :user_id
    add_foreign_key :bids, :users, column: :user_id
    add_foreign_key :deposits, :users, column: :user_id
    add_foreign_key :payment_methods, :users, column: :user_id
    add_foreign_key :products, :users, column: :user_id
    add_foreign_key :wallets, :users, column: :user_id
    add_foreign_key :chat_channels, :users, column: :user_id
    add_foreign_key :messages, :users, column: :user_id
  end
end
