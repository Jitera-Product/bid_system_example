class AddNewFieldsToChatChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_channels do |t|
      t.integer :status
      t.references :bid_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
