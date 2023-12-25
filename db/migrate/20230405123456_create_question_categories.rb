class CreateQuestionCategories < ActiveRecord::Migration[6.0]
  def up
    create_table :question_categories do |t|
      t.references :question, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :question_categories
  end
end
