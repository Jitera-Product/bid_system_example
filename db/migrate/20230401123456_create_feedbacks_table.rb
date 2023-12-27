class CreateFeedbacksTable < ActiveRecord::Migration[6.0]
  def up
    create_table :feedbacks do |t|
      t.integer :usefulness
      t.text :comment

      t.timestamps null: false
    end
  end

  def down
    drop_table :feedbacks
  end
end
