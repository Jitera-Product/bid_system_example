class AddForeignKeysToProducts < ActiveRecord::Migration[6.0]
  def change
    # Add foreign key for admin_id in products table
    unless foreign_key_exists?(:products, :admins)
      add_foreign_key :products, :admins, column: :admin_id
    end

    # Add foreign key for user_id in products table
    unless foreign_key_exists?(:products, :users)
      add_foreign_key :products, :users, column: :user_id
    end
  end
end
