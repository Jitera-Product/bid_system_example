class Feedback < ApplicationRecord
  # associations

  # validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true

  # custom methods
end
