
class Tag < ApplicationRecord
  # Associations
  has_many :question_tags
  has_many :question_tag_associations
  has_many :questions, through: :question_tag_associations

  # Validations
  validates :name, presence: true, uniqueness: true

  # Methods
  def self.find_or_create_by_name(tag_name)
    find_by(name: tag_name) || create(name: tag_name)
  end
end
