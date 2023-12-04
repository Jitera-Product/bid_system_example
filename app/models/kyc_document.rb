class KycDocument < ApplicationRecord
  belongs_to :user
  # validations
  validates :document_type, presence: { message: "Invalid document type." }
  validates :document_file, presence: { message: "Invalid file format." }
  validates :status, presence: true
  validates :user_id, numericality: { only_integer: true, message: "Wrong format" }
  validates :personal_information, presence: { message: "Personal information is required." }
end
