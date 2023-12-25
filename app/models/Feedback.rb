class Feedback < ApplicationRecord
  # Associations can be defined here if there are any. For example:
  # belongs_to :user
  # has_one :response

  # Validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true

  # Methods specific to the Feedback model can be defined here
end
