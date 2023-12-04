class KycDocument < ApplicationRecord
  belongs_to :user
  # validations
  validates :document_type, presence: true
  validates :document_file, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
end
