class CreateQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.text :question_text, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :questions, :user_id
  end
end
