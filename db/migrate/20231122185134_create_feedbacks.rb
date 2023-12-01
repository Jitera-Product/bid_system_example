class CreateFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.references :answer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
