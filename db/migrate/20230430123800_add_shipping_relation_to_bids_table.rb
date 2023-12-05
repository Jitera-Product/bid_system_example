class AddShippingRelationToBidsTable < ActiveRecord::Migration[6.0]
  def change
    # Add reference for bid_id in shippings table
    unless foreign_key_exists?(:shippings, :bids)
      add_reference :shippings, :bid, null: false, foreign_key: true, index: true
    end
  end
end
