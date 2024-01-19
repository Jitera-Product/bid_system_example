
class Answer < ApplicationRecord
  belongs_to :question

  # validations
  validates :content, presence: true
  validates :is_approved, inclusion: { in: [true, false] }
  validates :question_id, presence: true

  # Update the approval status of the answer
  def update_approval(is_approved)
    update(is_approved: is_approved)
  end
end
