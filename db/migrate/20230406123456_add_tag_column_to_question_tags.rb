class AddTagColumnToQuestionTags < ActiveRecord::Migration[6.0]
  def change
    add_column :question_tags, :tag, :string
  end
end
