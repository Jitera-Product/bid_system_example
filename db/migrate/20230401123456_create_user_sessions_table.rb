class CreateUserSessionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
    add_index :user_sessions, :token, unique: true
  end
end
