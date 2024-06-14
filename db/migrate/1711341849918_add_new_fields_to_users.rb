class AddNewFieldsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :display_name, :string
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :area, :string
    add_column :users, :menu, :text
    add_column :users, :images, :json
  end

  def down
    remove_column :users, :display_name
    remove_column :users, :gender
    remove_column :users, :date_of_birth
    remove_column :users, :area
    remove_column :users, :menu
    remove_column :users, :images
  end
end
