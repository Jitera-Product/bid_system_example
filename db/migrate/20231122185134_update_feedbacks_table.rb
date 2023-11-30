class UpdateFeedbacksTable < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :feedback_type, :string, null: false
  end
end
