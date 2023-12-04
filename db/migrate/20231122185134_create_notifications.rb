class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :activity_type
      t.text :details
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
