class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }

  # You can add any methods specific to the feedback model here
end
