class CreateFeedbacksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.integer :usefulness, null: false, default: 0
      t.text :comment

      t.timestamps null: false
    end
  end
end
