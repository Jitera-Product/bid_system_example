class AddForeignKeysToBids < ActiveRecord::Migration[6.0]
  def change
    # Add bid_item reference to bids table
    add_reference :bids, :bid_item, foreign_key: true unless foreign_key_exists?(:bids, :bid_item)

    # Add user reference to bids table
    add_reference :bids, :user, foreign_key: true unless foreign_key_exists?(:bids, :user)
  end
end
