class Tag < ApplicationRecord
  # relationships
  has_many :question_tags, dependent: :destroy
  has_many :question_tag_associations, dependent: :destroy

  # validations
  validates :name, presence: true
end
