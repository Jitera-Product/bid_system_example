class AddNewColumnsToChatChannels < ActiveRecord::Migration[6.0]
  def change
    change_table :chat_channels do |t|
      t.string :id, null: false, primary_key: true
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.boolean :is_active, default: true
      t.string :bid_item_id, null: false
      t.string :user_id, null: false
      t.index :bid_item_id
      t.index :user_id
    end
  end
end
