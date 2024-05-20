class AddNewFieldsToActiveStorageVariantRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :active_storage_variant_records, :created_at, :datetime, precision: 6, null: false
    add_column :active_storage_variant_records, :updated_at, :datetime, precision: 6, null: false
  end

  def down
    remove_column :active_storage_variant_records, :created_at
    remove_column :active_storage_variant_records, :updated_at
  end
end