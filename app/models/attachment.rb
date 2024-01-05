class Attachment < ApplicationRecord
  # Associations
  belongs_to :todo

  # Validations
  validates :file_path, presence: true
  validates :file_name, presence: true
  validates :todo_id, presence: true

  # Add a new column 'file' to the Attachment model
  has_one_attached :file

  # Custom methods (if any)
end
