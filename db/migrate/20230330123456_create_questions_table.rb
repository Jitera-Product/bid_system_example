class CreateQuestionsTable < ActiveRecord::Migration[6.0]
  def up
    create_table :questions do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end

    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      # other columns for answers table should be defined here based on your schema
      t.timestamps null: false
    end

    create_table :question_categories do |t|
      t.references :question, null: false, foreign_key: true
      # other columns for question_categories table should be defined here based on your schema
      t.timestamps null: false
    end
  end

  def down
    drop_table :question_categories
    drop_table :answers
    drop_table :questions
  end
end
