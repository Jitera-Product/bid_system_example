class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.string :feedback_type, null: false
      t.references :answer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
