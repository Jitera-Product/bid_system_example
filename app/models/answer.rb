class Answer < ApplicationRecord
  belongs_to :question

  # validations
  validates :answer_text, presence: true
  validates :question_id, presence: true, numericality: { only_integer: true }

  # Add any additional methods below this line
end
