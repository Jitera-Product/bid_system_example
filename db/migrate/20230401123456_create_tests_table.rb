# frozen_string_literal: true

class CreateTestsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :tests do |t|
      t.string :title, limit: 255

      t.timestamps
    end
  end
end
