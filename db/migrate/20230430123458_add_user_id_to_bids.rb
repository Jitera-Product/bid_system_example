class AddUserIdToBids < ActiveRecord::Migration[6.0]
  def change
    # Add user_id reference to bids table
    add_reference :bids, :user, foreign_key: true
  end
end
