class UpdateQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user, foreign_key: true
    add_column :questions, :feedback_type, :string, null: false
  end
end
