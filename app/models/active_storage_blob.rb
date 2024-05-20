class ActiveStorageBlob < ApplicationRecord
  has_many :active_storage_attachments, class_name: 'ActiveStorageAttachment', foreign_key: :blob_id
  has_many :active_storage_variant_records, class_name: 'ActiveStorageVariantRecord', foreign_key: :blob_id
end