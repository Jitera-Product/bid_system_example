class AddActionAndTimestampToUserActivities < ActiveRecord::Migration[6.0]
  def up
    add_column :user_activities, :action, :string
    add_column :user_activities, :timestamp, :datetime
  end

  def down
    remove_column :user_activities, :action
    remove_column :user_activities, :timestamp
  end
end
