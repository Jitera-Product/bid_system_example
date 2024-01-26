class CreateChatMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_messages do |t|
      t.text :message, null: false
      t.references :chat_session, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :chat_messages
  end
end
