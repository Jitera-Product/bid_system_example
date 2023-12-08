class AddAdminIdToCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :admin, foreign_key: true
  end
end
