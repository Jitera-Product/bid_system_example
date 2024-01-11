class CreateFeedbacksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.text :comment
      t.integer :usefulness

      t.timestamps null: false
    end
  end
end
