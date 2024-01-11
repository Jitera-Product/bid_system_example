class Feedback < ApplicationRecord
  # validations

  validates :comment, presence: true
  validates :usefulness, presence: true
  validates :content, presence: true  # Add validation for the new column 'content'

  # end for validations
end
