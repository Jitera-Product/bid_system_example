class CreateChatChannelsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_channels do |t|
      t.timestamps
      t.boolean :is_active
      t.references :bid_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
    add_index :chat_channels, :is_active
  end
end
