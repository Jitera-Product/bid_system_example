class Feedback < ApplicationRecord
  # validations
  enum usefulness: { helpful: 0, not_helpful: 1, neutral: 2 }

  validates :answer_id, presence: true, numericality: { only_integer: true }
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :usefulness, inclusion: { in: usefulness.keys }
  validates :comment, presence: true, allow_blank: true

  validate :answer_exists
  validate :user_exists

  # Custom validation to check if answer exists
  def answer_exists
    errors.add(:answer_id, "Answer not found.") unless Answer.exists?(self.answer_id)
  end

  # Custom validation to check if user exists
  def user_exists
    errors.add(:user_id, "User not found.") unless User.exists?(self.user_id)
  end
end
