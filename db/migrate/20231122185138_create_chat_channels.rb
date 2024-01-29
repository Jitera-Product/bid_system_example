class CreateChatChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_channels do |t|
      t.boolean :is_active, default: true, null: false
      t.references :bid_item, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
