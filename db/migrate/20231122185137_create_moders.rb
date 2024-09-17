class CreateModers < ActiveRecord::Migration[6.0]
  def change
    create_table :moders do |t|
      t.string :encrypted_password, limit: 255
      t.string :email, limit: 255
      t.string :reset_password_token, limit: 255
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip, limit: 255
      t.string :last_sign_in_ip, limit: 255
      t.integer :sign_in_count, limit: 8
      t.string :password, limit: 255
      t.string :password_confirmation, limit: 255
      t.datetime :locked_at
      t.integer :failed_attempts, limit: 8
      t.string :unlock_token, limit: 255
      t.string :confirmation_token, limit: 255
      t.string :unconfirmed_email, limit: 255
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end
  end
end
