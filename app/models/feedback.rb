class Feedback < ApplicationRecord
  # validations
  enum usefulness: { helpful: 0, not_helpful: 1 }
  validates :usefulness, presence: true, inclusion: { in: usefulness.keys }
  validates :answer_id, presence: true, numericality: { only_integer: true }
  validates :inquirer_id, presence: true, numericality: { only_integer: true }
  validates :comment, length: { maximum: 1000 }

  # associations
  belongs_to :answer, optional: false
  belongs_to :inquirer, class_name: 'User', foreign_key: 'inquirer_id', optional: false

  # Custom validation methods
  validate :answer_must_exist
  validate :inquirer_must_exist

  private

  def answer_must_exist
    errors.add(:answer_id, "Invalid answer ID.") unless Answer.exists?(self.answer_id)
  end

  def inquirer_must_exist
    errors.add(:inquirer_id, "Invalid inquirer ID.") unless User.exists?(self.inquirer_id)
  end
end
