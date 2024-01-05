class Tag < ApplicationRecord
  # Associations
  has_many :todo_tags, foreign_key: 'tag_id', dependent: :destroy

  # Validations
  validates :name, presence: true

  # Custom methods (if any)
end
