# This migration is for creating a new table called todo_categories
class CreateTodoCategoriesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_categories do |t|
      t.timestamps
      t.references :todo, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
    end
  end
end
