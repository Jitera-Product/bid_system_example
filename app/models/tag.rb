class Tag < ApplicationRecord
  has_many :question_tags, dependent: :destroy

  # validations
  validates :created_at, :updated_at, presence: true
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
