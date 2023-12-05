# frozen_string_literal: true

class UpdateProductsTable < ActiveRecord::Migration[6.1]
  def change
    change_table :products do |t|
      t.references :admin, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
