class QuestionCategory < ApplicationRecord
  # associations
  belongs_to :question
  belongs_to :category

  # validations
  validates :question_id, presence: true
  validates :category_id, presence: true
end
