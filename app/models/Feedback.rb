class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true

  # Define any custom methods that the new model might require here
end
