class Tag < ApplicationRecord
  has_many :question_tags, dependent: :destroy

  # validations
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
