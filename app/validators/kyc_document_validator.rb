class KycDocumentValidator
  include ActiveModel::Validations
  attr_accessor :id, :name, :kyc_status, :document_type, :document_file, :status, :user
  validates :id, :name, :kyc_status, :document_type, :document_file, :status, :user, presence: true
  validate :document_file_format, :document_file_validity, :input_matches_document
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  private
  def document_file_format
    # Add your logic to check the format of the document file
    # If the format is invalid, add an error to the errors collection
    # errors.add(:document_file, "is not in a valid format")
  end
  def document_file_validity
    # Add your logic to check the validity of the document file (e.g., whether it's expired)
    # If the document is invalid, add an error to the errors collection
    # errors.add(:document_file, "is not valid")
  end
  def input_matches_document
    # Add your logic to check whether the user's input matches the information in the document
    # If the input does not match, add an error to the errors collection
    # errors.add(:user, "input does not match the document")
  end
end
