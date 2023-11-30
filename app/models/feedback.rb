class Feedback < ApplicationRecord
  # validations
  validates :content, presence: true
  # methods
  def created_date
    created_at.strftime("%B %d, %Y")
  end
end
