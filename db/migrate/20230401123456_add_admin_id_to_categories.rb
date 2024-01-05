class AddAdminIdToCategories < ActiveRecord::Migration[7.0]
  def change
    # Assuming admin_id is an integer
    # If admin_id should be a bigint, replace :integer with :bigint
    add_reference :categories, :admin, foreign_key: true
  end
end
