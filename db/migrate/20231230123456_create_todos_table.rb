class CreateTodosTable < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :due_date
      t.integer :priority
      t.boolean :recurring, default: false
      t.boolean :is_completed, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end

    create_table :todo_categories do |t|
      t.references :todo, null: false, foreign_key: true
      t.timestamps null: false
    end

    create_table :todo_tags do |t|
      t.references :todo, null: false, foreign_key: true
      t.timestamps null: false
    end

    create_table :attachments do |t|
      t.references :todo, null: false, foreign_key: true
      t.timestamps null: false
    end
  end
end
