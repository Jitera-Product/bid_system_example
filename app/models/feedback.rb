class Feedback < ApplicationRecord
  # associations
  belongs_to :answer
  # validations
  validates :content, presence: true
  # methods
  def created_at
    attributes['created_at'].strftime("%m/%d/%Y %H:%M")
  end
  def updated_at
    attributes['updated_at'].strftime("%m/%d/%Y %H:%M")
  end
end
