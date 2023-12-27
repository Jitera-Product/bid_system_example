class CreateAnswersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.text :content, null: false
      t.references :question, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
