# frozen_string_literal: true

class UpdateBidsTable < ActiveRecord::Migration[6.1]
  def change
    change_table :bids do |t|
      t.integer :status, default: 0, null: false
      t.references :item, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false
      t.references :user, null: false, foreign_key: true
    end

    # Add an index on the status column for better query performance
    add_index :bids, :status
  end
end
