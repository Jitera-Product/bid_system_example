class Feedback < ApplicationRecord
  # Associations can be defined here if there are any. For example:
  # belongs_to :user
  # has_one :response

  # Validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true

  # Methods specific to the Feedback model can be defined here
end
