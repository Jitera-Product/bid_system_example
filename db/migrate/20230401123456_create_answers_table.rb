# frozen_string_literal: true

class CreateAnswersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :content
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
