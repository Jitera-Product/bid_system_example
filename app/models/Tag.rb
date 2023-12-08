class Tag < ApplicationRecord
  # Relationships
  has_many :todo_tags, dependent: :destroy

  # Validations
  validates :name, presence: true
end
