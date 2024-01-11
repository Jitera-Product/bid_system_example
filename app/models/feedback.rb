class Feedback < ApplicationRecord
  # validations

  validates :comment, presence: true
  validates :usefulness, presence: true

  # end for validations
end
