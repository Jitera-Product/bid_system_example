# This migration is responsible for creating the messages table
class CreateMessagesTable < ActiveRecord::Migration[6.0]
  def change
    # Use Active Record's configured type for primary and foreign keys
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :messages, id: primary_key_type do |t|
      t.text :content, null: false
      t.references :chat_channel, null: false, foreign_key: true, type: foreign_key_type

      if connection.supports_datetime_with_precision?
        t.datetime :created_at, precision: 6, null: false
        t.datetime :updated_at, precision: 6, null: false
      else
        t.datetime :created_at, null: false
        t.datetime :updated_at, null: false
      end
    end
  end

  private

  def primary_and_foreign_key_types
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    primary_key_type = setting || :primary_key
    foreign_key_type = setting || :bigint
    [primary_key_type, foreign_key_type]
  end
end
