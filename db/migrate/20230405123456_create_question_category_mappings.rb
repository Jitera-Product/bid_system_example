class CreateQuestionCategoryMappings < ActiveRecord::Migration[6.0]
  def up
    create_table :question_category_mappings do |t|
      t.references :question, null: false, foreign_key: true
      t.references :question_category, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :question_category_mappings
  end
end
