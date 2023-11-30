class UpdateUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :location, :string
    add_column :users, :interests, :text
    add_column :users, :preferences, :text
  end
end
