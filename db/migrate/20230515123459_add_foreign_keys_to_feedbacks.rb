class AddForeignKeysToFeedbacks < ActiveRecord::Migration[6.0]
  def change
    # Add user_id as a foreign key to feedbacks table
    add_reference :feedbacks, :user, null: false, foreign_key: true

    # Add product_id as a foreign key to feedbacks table
    add_reference :feedbacks, :product, null: false, foreign_key: true

    # Add indexes to foreign key columns for better query performance
    add_index :feedbacks, :user_id
    add_index :feedbacks, :product_id
  end
end
