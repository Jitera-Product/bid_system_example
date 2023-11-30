class CreateMatchesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :compatibility_score
      t.string :status
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
