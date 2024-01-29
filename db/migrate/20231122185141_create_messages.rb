class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :chat_channel, null: false, foreign_key: true

      t.timestamps
    end
    add_index :messages, :chat_channel_id
  end
end
