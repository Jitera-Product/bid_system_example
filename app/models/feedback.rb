class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true

  # You can add more validations here if needed
end
