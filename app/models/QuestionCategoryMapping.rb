class QuestionCategoryMapping < ApplicationRecord
  # Associations
  belongs_to :question
  belongs_to :question_category

  # Validations
  validates :question_id, presence: true
  validates :question_category_id, presence: true

  # Add any additional scopes or methods below
end
