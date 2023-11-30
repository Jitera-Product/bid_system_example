class UpdateQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :questions do |t|
      t.change :content, :string, limit: 255, null: false
      t.references :user, foreign_key: true
      t.column :feedback_type, :string, null: false
    end
  end
end
