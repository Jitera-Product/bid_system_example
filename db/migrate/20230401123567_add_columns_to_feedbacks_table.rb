class AddColumnsToFeedbacksTable < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :id, :primary_key
    add_column :feedbacks, :created_at, :datetime, null: false
    add_column :feedbacks, :updated_at, :datetime, null: false
    add_column :feedbacks, :usefulness, :integer, null: false, default: 0
    add_column :feedbacks, :comment, :text
  end
end
