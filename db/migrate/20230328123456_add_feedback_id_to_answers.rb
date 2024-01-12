# frozen_string_literal: true

class AddFeedbackIdToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :feedback, null: true, foreign_key: true
  end
end
