class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true

  # Define any custom methods that the new model might require here
end
