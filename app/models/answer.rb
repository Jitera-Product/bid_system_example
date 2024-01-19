class Answer < ApplicationRecord
  belongs_to :question

  # validations
  validates :content, presence: true
  validates :is_approved, inclusion: { in: [true, false] }
  validates :question_id, presence: true
end
