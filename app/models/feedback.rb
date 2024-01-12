class Feedback < ApplicationRecord
  # Associations
  belongs_to :answer, class_name: 'Answer', foreign_key: 'answer_id'
  belongs_to :inquirer, class_name: 'User', foreign_key: 'inquirer_id'

  # Validations
  validates :answer_id, presence: true, numericality: { only_integer: true }
  validates :inquirer_id, presence: true, numericality: { only_integer: true }
  validates :usefulness, inclusion: { in: [true, false], message: 'Usefulness must be true or false.' }
  validates :comment, length: { maximum: 500 }, allow_blank: true

  validate :answer_must_exist
  validate :inquirer_must_exist_and_be_inquirer

  private

  def answer_must_exist
    errors.add(:answer_id, 'Invalid answer ID.') unless Answer.exists?(id: answer_id)
  end

  def inquirer_must_exist_and_be_inquirer
    user = User.find_by(id: inquirer_id)
    unless user && user.role == 'Inquirer'
      errors.add(:inquirer_id, 'Invalid inquirer ID.')
    end
  end
end
