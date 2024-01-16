# frozen_string_literal: true

class CreateQuestionTagsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :question_tags do |t|
      t.timestamps
      t.references :question, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end
  end
end
