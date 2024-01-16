class Feedback < ApplicationRecord
  enum usefulness: {
    very_useful: 'very_useful',
    useful: 'useful',
    not_useful: 'not_useful',
    not_helpful: 0, # New enum values added
    helpful: 1,
    very_helpful: 2
  }
   
  # validations
  validates :comment, presence: true
  validates :answer_id, presence: true
  validates :user_id, presence: true
  validate :answer_exists
  validate :user_exists
  validate :usefulness_valid_value

  private

  def answer_exists
    errors.add(:answer_id, "Answer not found.") unless Answer.exists?(self.answer_id)
  end

  def user_exists
    errors.add(:user_id, "User not found.") unless User.exists?(self.user_id)
  end

  def usefulness_valid_value
    errors.add(:usefulness, "Invalid value for usefulness.") unless Feedback.usefulnesses.keys.include?(self.usefulness)
  end
end
