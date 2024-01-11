class Tag < ApplicationRecord
  # Relationships
  has_many :question_tags, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
