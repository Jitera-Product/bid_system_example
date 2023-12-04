class AddIndexesAndRelationsToUsers < ActiveRecord::Migration[6.0]
  def change
    # Adding indexes to improve query performance
    add_index :users, :username, unique: true unless index_exists?(:users, :username)
    add_index :users, :sign_in_count unless index_exists?(:users, :sign_in_count)
    add_index :users, :last_sign_in_at unless index_exists?(:users, :last_sign_in_at)
    add_index :users, :current_sign_in_at unless index_exists?(:users, :current_sign_in_at)
    add_index :users, :failed_attempts unless index_exists?(:users, :failed_attempts)
    add_index :users, :locked_at unless index_exists?(:users, :locked_at)
    add_index :users, :is_owner unless index_exists?(:users, :is_owner)

    # Adding relationships
    # Note: The relationships have been added in the previous migration file.
    # If there are new tables that need to reference the users table, they should be added here.
    # Example:
    # add_reference :new_table, :user, foreign_key: true unless foreign_key_exists?(:new_table, :user)
  end
end
