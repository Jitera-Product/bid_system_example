class Feedback < ApplicationRecord
  # validations
  validates :content, presence: true
  # associations
  belongs_to :user
  # methods
  def self.create_feedback(user, content)
    feedback = self.new(user: user, content: content)
    if feedback.save
      return feedback
    else
      return false
    end
  end
end
