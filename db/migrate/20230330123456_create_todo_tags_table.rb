# This migration is for creating a new table called todo_tags
class CreateTodoTagsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_tags do |t|
      t.references :todo, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    # Adding an index can improve the speed of operations on this table
    add_index :todo_tags, [:todo_id, :tag_id], unique: true
  end
end
