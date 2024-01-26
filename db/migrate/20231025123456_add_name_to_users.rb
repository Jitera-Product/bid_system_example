class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :name
    end
  end

  def down
    remove_column :users, :name
  end
end
