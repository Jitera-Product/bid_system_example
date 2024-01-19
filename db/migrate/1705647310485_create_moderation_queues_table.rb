# frozen_string_literal: true

class CreateModerationQueuesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :moderation_queues do |t|
      t.string :content_type
      t.string :status
      t.text :reason

      t.timestamps
    end
  end
end
