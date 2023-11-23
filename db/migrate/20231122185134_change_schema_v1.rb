class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :deposits do |t|
      t.integer :value, null: false

      t.integer :status, null: false, default: Deposit.statuses['new']

      t.timestamps null: false
    end

    create_table :payment_methods do |t|
      t.boolean :primary, default: false

      t.integer :method, null: false, default: 0

      t.timestamps null: false
    end

    create_table :products do |t|
      t.integer :price, null: false

      t.text :description

      t.string :name, null: false, default: ''

      t.integer :stock

      t.integer :admin_id, index: true

      t.timestamps null: false
    end

    create_table :categories do |t|
      t.integer :admin_id, index: true

      t.boolean :disabled, default: false

      t.string :name, null: false, default: ''

      t.timestamps null: false
    end

    create_table :wallets do |t|
      t.integer :balance, null: false

      t.boolean :locked, default: false

      t.timestamps null: false
    end

    create_table :product_categories do |t|
      t.timestamps null: false
    end

    create_table :bid_items do |t|
      t.integer :base_price, null: false

      t.string :name, null: false, default: 'Product Name'

      t.datetime :expiration_time, null: false

      t.integer :status, null: false, default: BidItem.statuses['draft']

      t.timestamps null: false
    end

    create_table :withdrawals do |t|
      t.integer :admin_id, index: true

      t.integer :value, null: false

      t.integer :status, null: false, default: Withdrawal.statuses['ready']

      t.timestamps null: false
    end

    create_table :shippings do |t|
      t.string :full_name, null: false, default: ''

      t.string :shiping_address, null: false, default: ''

      t.string :phone_number, null: false, default: ''

      t.string :email, null: false, default: ''

      t.integer :post_code

      t.integer :status, null: false, default: Shipping.statuses['new']

      t.timestamps null: false
    end

    create_table :admins do |t|
      t.datetime :current_sign_in_at

      t.string :unlock_token

      t.datetime :locked_at

      t.integer :failed_attempts, null: false, default: 0

      t.string :unconfirmed_email

      t.string :email, null: false, default: ''

      t.string :encrypted_password, null: false, default: ''

      t.string :password

      t.integer :sign_in_count, null: false, default: 0

      t.string :name, null: false, default: ''

      t.datetime :reset_password_sent_at

      t.datetime :last_sign_in_at

      t.string :last_sign_in_ip

      t.datetime :confirmation_sent_at

      t.string :current_sign_in_ip

      t.string :confirmation_token

      t.datetime :confirmed_at

      t.string :reset_password_token

      t.datetime :remember_created_at

      t.string :password_confirmation

      t.timestamps null: false
    end

    create_table :users do |t|
      t.datetime :confirmed_at

      t.string :unlock_token

      t.string :unconfirmed_email

      t.integer :sign_in_count, null: false, default: 0

      t.datetime :remember_created_at

      t.datetime :last_sign_in_at

      t.string :confirmation_token

      t.string :password

      t.string :password_confirmation

      t.string :current_sign_in_ip

      t.string :last_sign_in_ip

      t.datetime :locked_at

      t.datetime :current_sign_in_at

      t.string :email, null: false, default: ''

      t.datetime :reset_password_sent_at

      t.string :reset_password_token

      t.datetime :confirmation_sent_at

      t.string :encrypted_password, null: false, default: ''

      t.integer :failed_attempts, null: false, default: 0

      t.timestamps null: false
    end

    create_table :listing_bid_items do |t|
      t.timestamps null: false
    end

    create_table :bids do |t|
      t.integer :status, null: false, default: Bid.statuses['new']

      t.integer :item_id, index: true

      t.integer :price, null: false

      t.timestamps null: false
    end

    create_table :transactions do |t|
      t.integer :reference_type, null: false, default: 0

      t.integer :status, null: false, default: 0

      t.integer :transaction_type, null: false, default: 0

      t.integer :reference_id, null: false

      t.integer :value

      t.timestamps null: false
    end

    create_table :listings do |t|
      t.text :description

      t.timestamps null: false
    end

    add_reference :payment_methods, :user, foreign_key: true

    add_reference :transactions, :wallet, foreign_key: true

    add_reference :listing_bid_items, :bid_item, foreign_key: true

    add_reference :bid_items, :product, foreign_key: true

    add_reference :withdrawals, :payment_method, foreign_key: true

    add_reference :shippings, :bid, foreign_key: true

    add_reference :wallets, :user, foreign_key: true

    add_reference :deposits, :payment_method, foreign_key: true

    add_reference :deposits, :wallet, foreign_key: true

    add_reference :listing_bid_items, :listing, foreign_key: true

    add_reference :bids, :user, foreign_key: true

    add_reference :product_categories, :category, foreign_key: true

    add_reference :product_categories, :product, foreign_key: true

    add_reference :bid_items, :user, foreign_key: true

    add_reference :products, :user, foreign_key: true

    add_reference :deposits, :user, foreign_key: true

    add_index :admins, :unlock_token, unique: true
    add_index :admins, :unconfirmed_email, unique: true
    add_index :admins, :email, unique: true
    add_index :admins, :confirmation_token, unique: true
    add_index :admins, :reset_password_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :unconfirmed_email, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
