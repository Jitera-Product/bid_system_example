class AddRelationsToQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    # Since the relationships are already defined in the model,
    # we just need to ensure that the foreign keys are indexed for performance reasons.
    add_index :answers, :question_id
    add_index :question_tags, :question_id
    add_index :question_categories, :question_id
  end
end
