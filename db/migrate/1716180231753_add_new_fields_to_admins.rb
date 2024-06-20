class AddNewFieldsToAdmins < ActiveRecord::Migration[6.0]
  def up
    add_column :admins, :new_field1, :string
    add_column :admins, :new_field2, :integer
    # Add other new fields here
  end

  def down
    remove_column :admins, :new_field1
    remove_column :admins, :new_field2
    # Remove other new fields here
  end
end