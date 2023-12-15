class CreateQuestionTagsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :question_tags do |t|
      t.references :question, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
