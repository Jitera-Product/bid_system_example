class CreateChatSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_sessions do |t|
      t.boolean :is_active, null: false, default: true
      t.references :bid_item, null: false, foreign_key: true

      t.timestamps null: false
    end

    # Add indexes if necessary
    # add_index :chat_sessions, :is_active
  end
end

