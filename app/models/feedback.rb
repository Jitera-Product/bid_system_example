class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates :answer_id, presence: true
  validates :inquirer_id, presence: true
  validates :comment, length: { maximum: 500 }, allow_blank: true

  # associations
  belongs_to :answer

  # You can add more validations here if needed
end
