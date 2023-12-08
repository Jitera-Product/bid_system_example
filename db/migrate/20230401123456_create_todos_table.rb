class CreateTodosTable < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.integer :priority
      t.boolean :recurring
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :todos, :title
    add_index :todos, :due_date
    add_index :todos, :priority
    add_index :todos, :recurring
  end
end
