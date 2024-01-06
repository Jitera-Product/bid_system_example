class AddQuestionTagIdToTags < ActiveRecord::Migration[6.0]
  def change
    add_reference :tags, :question_tag, foreign_key: true
  end
end
