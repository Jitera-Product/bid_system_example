class Feedback < ApplicationRecord
  # validations

  validates :comment, presence: true
  validates :usefulness, numericality: { only_integer: true }

  # end for validations
end
