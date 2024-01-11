class AddRelationsToQuestions < ActiveRecord::Migration[6.0]
  def change
    # Add index to :user_id column in :questions table for better query performance
    add_index :questions, :user_id

    # Create question_tags table
    create_table :question_tags do |t|
      t.references :question, null: false, foreign_key: true
      t.timestamps null: false
    end

    # Create question_tag_associations table
    create_table :question_tag_associations do |t|
      t.references :question, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps null: false
    end
  end
end
