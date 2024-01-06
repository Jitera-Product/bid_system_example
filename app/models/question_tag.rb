class QuestionTag < ApplicationRecord
  # Associations
  belongs_to :question
  belongs_to :tag

  # Validations
  validates :question_id, presence: true
  validates :tag_id, presence: true
end
