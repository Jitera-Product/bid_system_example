class CreateTagsTable < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?(:tags)

    # Use Active Record's configured type for primary and foreign keys
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :tags, id: primary_key_type do |t|
      t.string :name, null: false

      if connection.supports_datetime_with_precision?
        t.datetime :created_at, precision: 6, null: false
        t.datetime :updated_at, precision: 6, null: false
      else
        t.datetime :created_at, null: false
        t.datetime :updated_at, null: false
      end
    end

    create_table :todo_tags, id: primary_key_type do |t|
      t.references :tag, null: false, type: foreign_key_type, index: true
      t.references :todo, null: false, type: foreign_key_type, index: true

      if connection.supports_datetime_with_precision?
        t.datetime :created_at, precision: 6, null: false
        t.datetime :updated_at, precision: 6, null: false
      else
        t.datetime :created_at, null: false
        t.datetime :updated_at, null: false
      end

      t.index [:tag_id, :todo_id], unique: true
      t.foreign_key :tags, column: :tag_id
      t.foreign_key :todos, column: :todo_id
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
