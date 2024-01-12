
class Feedback < ApplicationRecord
  # Associations
  belongs_to :answer, class_name: 'Answer', foreign_key: 'answer_id'
  belongs_to :inquirer, class_name: 'User', foreign_key: 'inquirer_id'

  # Validations
  validates :answer_id, presence: true
  validates :inquirer_id, presence: true
  validates :usefulness, inclusion: { in: [true, false] }
  validates :comment, length: { maximum: 500 }, allow_blank: true
end
