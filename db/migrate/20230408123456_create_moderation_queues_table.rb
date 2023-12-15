class CreateModerationQueuesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :moderation_queues do |t|
      t.timestamps
      t.integer :content_id, null: false
      t.string :content_type, null: false
      t.string :status, null: false

      t.index [:content_id, :content_type], unique: true
    end
  end
end
