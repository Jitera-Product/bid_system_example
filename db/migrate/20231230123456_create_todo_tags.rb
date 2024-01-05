class CreateTodoTags < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_tags do |t|
      t.references :todo, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
