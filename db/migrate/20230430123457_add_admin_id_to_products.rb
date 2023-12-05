class AddAdminIdToProducts < ActiveRecord::Migration[6.0]
  def change
    # Add a reference to admins table
    add_reference :products, :admin, foreign_key: true
  end
end
