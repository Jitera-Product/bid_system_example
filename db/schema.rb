# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_22_185136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.datetime "current_sign_in_at", precision: nil
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.integer "failed_attempts", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "password"
    t.integer "sign_in_count", default: 0, null: false
    t.string "name", default: "", null: false
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "confirmation_sent_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.string "reset_password_token"
    t.datetime "remember_created_at", precision: nil
    t.string "password_confirmation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unconfirmed_email"], name: "index_admins_on_unconfirmed_email", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "bid_items", force: :cascade do |t|
    t.integer "base_price", null: false
    t.string "name", default: "Product Name", null: false
    t.datetime "expiration_time", precision: nil, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "user_id"
    t.index ["product_id"], name: "index_bid_items_on_product_id"
    t.index ["user_id"], name: "index_bid_items_on_user_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "item_id"
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["item_id"], name: "index_bids_on_item_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "admin_id"
    t.boolean "disabled", default: false
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_categories_on_admin_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.integer "value", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_method_id"
    t.bigint "wallet_id"
    t.bigint "user_id"
    t.index ["payment_method_id"], name: "index_deposits_on_payment_method_id"
    t.index ["user_id"], name: "index_deposits_on_user_id"
    t.index ["wallet_id"], name: "index_deposits_on_wallet_id"
  end

  create_table "listing_bid_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bid_item_id"
    t.bigint "listing_id"
    t.index ["bid_item_id"], name: "index_listing_bid_items_on_bid_item_id"
    t.index ["listing_id"], name: "index_listing_bid_items_on_listing_id"
  end

  create_table "listings", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "revoked_at", precision: nil
    t.string "scopes", default: "", null: false
    t.string "resource_owner_type", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id", "resource_owner_type"], name: "polymorphic_owner_oauth_access_grants"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.string "resource_owner_type"
    t.integer "refresh_expires_in"
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id", "resource_owner_type"], name: "polymorphic_owner_oauth_access_tokens"
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "payment_methods", force: :cascade do |t|
    t.boolean "primary", default: false
    t.integer "method", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_payment_methods_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "product_id"
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "price", null: false
    t.text "description"
    t.string "name", default: "", null: false
    t.integer "stock"
    t.integer "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["admin_id"], name: "index_products_on_admin_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "shippings", force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "shiping_address", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "email", default: "", null: false
    t.integer "post_code"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bid_id"
    t.index ["bid_id"], name: "index_shippings_on_bid_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "reference_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "transaction_type", default: 0, null: false
    t.integer "reference_id", null: false
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "wallet_id"
    t.index ["wallet_id"], name: "index_transactions_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmed_at", precision: nil
    t.string "unlock_token"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "confirmation_token"
    t.string "password"
    t.string "password_confirmation"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.datetime "current_sign_in_at", precision: nil
    t.string "email", default: "", null: false
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "confirmation_sent_at", precision: nil
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unconfirmed_email"], name: "index_users_on_unconfirmed_email", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "balance", null: false
    t.boolean "locked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "withdrawals", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "value", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_method_id"
    t.index ["admin_id"], name: "index_withdrawals_on_admin_id"
    t.index ["payment_method_id"], name: "index_withdrawals_on_payment_method_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bid_items", "products"
  add_foreign_key "bid_items", "users"
  add_foreign_key "bids", "users"
  add_foreign_key "deposits", "payment_methods"
  add_foreign_key "deposits", "users"
  add_foreign_key "deposits", "wallets"
  add_foreign_key "listing_bid_items", "bid_items"
  add_foreign_key "listing_bid_items", "listings"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "payment_methods", "users"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "products", "users"
  add_foreign_key "shippings", "bids"
  add_foreign_key "transactions", "wallets"
  add_foreign_key "wallets", "users"
  add_foreign_key "withdrawals", "payment_methods"
  add_foreign_key "withdrawals", "admins"
  add_foreign_key "products", "admins"
  add_foreign_key "categories", "admins"
end
