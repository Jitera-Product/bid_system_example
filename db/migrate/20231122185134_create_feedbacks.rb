class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.references :feedback_id, null: false, foreign_key: { to_table: :answers }
      t.string :feedback_type, null: false
      t.timestamps
    end
  end
end
