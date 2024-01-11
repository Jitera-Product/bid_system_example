class CreateQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :category, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
