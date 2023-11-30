class Feedback < ApplicationRecord
  # associations
  has_many :answers, foreign_key: 'feedback_id', dependent: :destroy
  # validations
  validates :content, presence: true
  # methods
  def created_date
    created_at.strftime("%B %d, %Y")
  end
end
