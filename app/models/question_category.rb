class QuestionCategory < ApplicationRecord
  # Relationships
  belongs_to :question
  belongs_to :category

  # Validations
  validates :question_id, presence: true
  validates :category_id, presence: true
end
