class AddChatChannelsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_channels do |t|
      t.boolean :is_active, default: true
      t.boolean :is_closed, default: false
      t.references :bid_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
