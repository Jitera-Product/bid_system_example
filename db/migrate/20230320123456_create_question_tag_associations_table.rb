class CreateQuestionTagAssociationsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :question_tag_associations do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
