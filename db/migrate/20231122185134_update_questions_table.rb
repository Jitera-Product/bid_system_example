class UpdateQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :feedback_type, :string, null: false
  end
end
