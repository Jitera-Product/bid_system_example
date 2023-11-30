class UpdateAnswersTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :feedback, foreign_key: true
  end
end
