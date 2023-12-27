class CreateFeedbacksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.integer :usefulness
      t.text :comment

      t.timestamps null: false
    end
  end
end
