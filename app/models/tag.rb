class Tag < ApplicationRecord
  # Associations
  has_many :question_tags, foreign_key: 'tag_id', dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true

  # Methods specific to the Tag model can be added here
end
