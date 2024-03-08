class AddDisabledToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :disabled, :boolean, default: false, null: false
    add_index :categories, :admin_id
  end
end
