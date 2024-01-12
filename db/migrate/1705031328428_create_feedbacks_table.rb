# frozen_string_literal: true

class CreateFeedbacksTable < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.integer :usefulness
      t.text :comment

      t.timestamps
    end
  end
end
