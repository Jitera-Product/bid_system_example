# frozen_string_literal: true

class AddAdminIdToCategories < ActiveRecord::Migration[7.0]
  def change
    # Add the admin_id column to the categories table
    unless column_exists?(:categories, :admin_id)
      add_column :categories, :admin_id, :bigint
      add_index :categories, :admin_id
    end

    # Add a foreign key to the admins table
    unless foreign_key_exists?(:categories, :admins)
      add_foreign_key :categories, :admins, column: :admin_id
    end
  end
end
