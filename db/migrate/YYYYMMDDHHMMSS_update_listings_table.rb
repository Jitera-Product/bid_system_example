# frozen_string_literal: true

class UpdateListingsTable < ActiveRecord::Migration[6.1]
  def change
    change_table :listings do |t|
      # Assuming the 'description' column already exists and needs to be updated
      # with a new type or constraints, you would modify it like so:
      # t.change :description, :text, limit: 65_535

      # If there are new columns to be added, you would use `t.column`:
      # t.column :new_column_name, :new_column_type

      # If you need to add an index to a column:
      # t.index :column_name, unique: true

      # If you need to add a foreign key to another table:
      # t.references :other_table_name, foreign_key: true

      # Since the guideline does not specify new columns or changes,
      # and the current code does not indicate any required updates,
      # no changes are made here.
    end
  end
end
