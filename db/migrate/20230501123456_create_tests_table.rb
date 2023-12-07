# This migration is responsible for creating the tests table
class CreateTestsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :tests do |t|
      t.string :name, limit: 255

      t.timestamps
    end
  end
end
