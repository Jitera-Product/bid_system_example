class Feedback < ApplicationRecord
  # associations
  # Assuming Feedback is related to a User model, if not, please adjust accordingly.
  belongs_to :user

  # validations
  validates :usefulness, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true

  # custom methods
  # Define any custom methods that might be necessary for the Feedback model here.
end
