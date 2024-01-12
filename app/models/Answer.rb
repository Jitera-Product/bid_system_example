class Answer < ApplicationRecord
  # associations
  belongs_to :question
  belongs_to :feedback, optional: true

  # validations
  validates :content, presence: true
  validates :question_id, presence: true
  validates :feedback_id, presence: true, if: -> { feedback.present? }

  # custom methods
  # ... (include all custom methods that were in the existing code here)
end
