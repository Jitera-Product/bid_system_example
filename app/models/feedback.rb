class Feedback < ApplicationRecord
  # Associations
  has_many :answers, class_name: 'Answer', foreign_key: 'feedback_id', dependent: :destroy

  # Validations
  validates :usefulness, inclusion: { in: [1, 2, 3, 4, 5] }, allow_nil: true
  validates :comment, length: { maximum: 500 }, allow_blank: true
end
