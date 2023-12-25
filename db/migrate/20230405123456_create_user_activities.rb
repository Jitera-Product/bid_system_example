class CreateUserActivities < ActiveRecord::Migration[6.0]
  def up
    create_table :user_activities do |t|
      t.string :activity_type
      t.text :activity_description
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :user_activities
  end
end
