class CreateUsersTable < ActiveRecord::Migration[6.0]
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
      t.string :username
      t.boolean :is_owner, default: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :unconfirmed_email, unique: true

    # Relations
    add_reference :bid_items, :user, foreign_key: true
    add_reference :bids, :user, foreign_key: true
    add_reference :deposits, :user, foreign_key: true
    add_reference :payment_methods, :user, foreign_key: true
    add_reference :products, :user, foreign_key: true
    add_reference :wallets, :user, foreign_key: true
  end
end
