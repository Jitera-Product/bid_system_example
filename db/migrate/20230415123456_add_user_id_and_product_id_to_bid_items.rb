class AddUserIdAndProductIdToBidItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :bid_items, :user, foreign_key: true
    add_reference :bid_items, :product, foreign_key: true
  end
end
