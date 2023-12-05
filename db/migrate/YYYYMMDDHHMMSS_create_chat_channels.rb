# frozen_string_literal: true

class CreateChatChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_channels do |t|
      t.references :bid_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
