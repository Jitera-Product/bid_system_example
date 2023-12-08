class Attachment < ApplicationRecord
  belongs_to :todo

  # validations

  validates :file_name, presence: true
  validates :file_content, presence: true
  validates :todo_id, presence: true

  # end for validations
end
