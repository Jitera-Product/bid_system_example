class Feedback < ApplicationRecord
  # validations
  validates :comment, presence: true
  validates :usefulness, numericality: { only_integer: true }

  # You can add custom methods here if required
end
