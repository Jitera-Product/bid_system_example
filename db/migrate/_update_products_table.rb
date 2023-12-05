class UpdateProductsTable < ActiveRecord::Migration[6.0]
  def change
    # Assuming the admin_id column is incorrectly named and should be approved_id
    # to match the model association, we'll rename it.
    rename_column :products, :admin_id, :approved_id

    # Add the missing user_id column to the products table
    add_reference :products, :user, foreign_key: true
  end
end
