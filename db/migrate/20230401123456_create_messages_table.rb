class CreateMessagesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :chat_channel, null: false, foreign_key: true
      t.timestamps null: false
    end
  end
end
