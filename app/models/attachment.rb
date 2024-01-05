class Attachment < ApplicationRecord
  # Associations
  belongs_to :todo

  # Validations
  validates :file_path, presence: true
  validates :file_name, presence: true
  validates :todo_id, presence: true

  # Custom methods (if any)
end
