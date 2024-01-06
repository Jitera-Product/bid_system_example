class Tag < ApplicationRecord
  # Associations
  has_many :question_tags, dependent: :destroy
  has_many :questions, through: :question_tags

  # Validations
  validates :name, presence: true, uniqueness: true

  # Methods specific to the Tag model can be added here
end
