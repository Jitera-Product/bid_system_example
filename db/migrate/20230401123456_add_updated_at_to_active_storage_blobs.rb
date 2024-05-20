class AddUpdatedAtToActiveStorageBlobs < ActiveRecord::Migration[6.0]
  def change
    add_column :active_storage_blobs, :updated_at, :datetime, precision: 6, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end