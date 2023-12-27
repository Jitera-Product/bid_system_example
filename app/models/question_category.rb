class QuestionCategory < ApplicationRecord
  # associations
  belongs_to :question
  belongs_to :category
  has_many :question_category_mappings, dependent: :destroy

  # validations
  validates :question_id, presence: true
  validates :category_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 500 }, allow_blank: true
end
