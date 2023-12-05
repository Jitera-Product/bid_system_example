class AddAdminIdToProducts < ActiveRecord::Migration[6.0]
  def change
    # Add a reference to admins table
    add_reference :products, :admin, foreign_key: true
    # Add an index to the admin_id foreign key for better query performance
    add_index :products, :admin_id
  end
end
