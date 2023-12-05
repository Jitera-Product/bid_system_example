class AddUserIdToBids < ActiveRecord::Migration[6.0]
  def change
    # Add user_id reference to bids table
    add_reference :bids, :user, foreign_key: true

    # Add index to user_id for better query performance
    add_index :bids, :user_id
  end
end
