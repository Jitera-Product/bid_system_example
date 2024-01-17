# frozen_string_literal: true

class CreateQuestionsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
