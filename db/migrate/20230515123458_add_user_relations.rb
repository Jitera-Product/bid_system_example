class AddUserRelations < ActiveRecord::Migration[6.0]
  def change
    # Since the user table and bid_items table are already created and the user reference is added to bid_items,
    # we only need to add the user references to the other tables mentioned in the relations.

    # Add user reference to bids table
    add_reference :bids, :user, foreign_key: true unless foreign_key_exists?(:bids, :user)

    # Add user reference to deposits table
    add_reference :deposits, :user, foreign_key: true unless foreign_key_exists?(:deposits, :user)

    # Add user reference to payment_methods table
    add_reference :payment_methods, :user, foreign_key: true unless foreign_key_exists?(:payment_methods, :user)

    # Add user reference to products table
    add_reference :products, :user, foreign_key: true unless foreign_key_exists?(:products, :user)

    # Add user reference to wallets table
    add_reference :wallets, :user, foreign_key: true unless foreign_key_exists?(:wallets, :user)
  end
end
