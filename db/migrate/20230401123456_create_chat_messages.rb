# frozen_string_literal: true

class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.text :content
      t.references :chat_channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end