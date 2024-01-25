class CreateChatSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_sessions do |t|
      t.boolean :is_active, null: false
      t.references :bid_item, null: false, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end

