class Tag < ApplicationRecord
  # Associations
  has_many :question_tags, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }

  # Custom methods
  # Define any custom methods that you need for this model here
end
