class CreateChatChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_channels do |t|
      t.boolean :is_closed
      t.references :user, null: false, foreign_key: true
      t.references :bid_item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
