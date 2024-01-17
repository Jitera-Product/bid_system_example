class Feedback < ApplicationRecord
  # validations
  enum usefulness: { helpful: 0, not_helpful: 1, neutral: 2 }

  validates :comment, presence: true
  validates :usefulness, numericality: { only_integer: true }

  # end for validations
end
