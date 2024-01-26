class CreateChatSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_sessions do |t|
      t.boolean :is_active, default: true, null: false
      t.references :bid_item, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :chat_sessions
  end
end

