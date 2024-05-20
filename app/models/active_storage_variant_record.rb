class ActiveStorageVariantRecord < ApplicationRecord
  belongs_to :blob, class_name: 'ActiveStorageBlob'

  validates :variation_digest, presence: true
end