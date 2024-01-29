class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.references :chat_channel, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end

