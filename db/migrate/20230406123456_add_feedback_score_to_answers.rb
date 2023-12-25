class AddFeedbackScoreToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :feedback_score, :integer
  end
end
