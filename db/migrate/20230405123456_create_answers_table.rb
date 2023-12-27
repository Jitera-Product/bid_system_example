class CreateAnswersTable < ActiveRecord::Migration[6.0]
  def up
    create_table :answers do |t|
      t.text :content
      t.references :question, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :answers
  end
end
