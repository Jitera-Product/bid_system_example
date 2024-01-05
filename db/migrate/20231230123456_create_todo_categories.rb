class CreateTodoCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :todo_categories do |t|
      t.timestamps null: false
    end

    add_reference :todo_categories, :todo, foreign_key: true
    add_reference :todo_categories, :category, foreign_key: true
  end
end
