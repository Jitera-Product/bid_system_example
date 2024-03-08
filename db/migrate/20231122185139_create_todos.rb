class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :due_date, null: false
      t.integer :priority, null: false
      t.boolean :recurring, default: false
      t.json :attachments

      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
