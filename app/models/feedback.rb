class Feedback < ApplicationRecord
  # relationships
  # Add any new relationships here. For example, if feedbacks belong to a user:
  # belongs_to :user

  # validations
  validates :comment, presence: true
  validates :usefulness, presence: true
  validates :content, presence: true  # This line is the same in both new and existing code

  # Add any custom methods here. For example, if there's a method to calculate feedback score:
  # def calculate_score
  #   # method implementation
  # end
end
