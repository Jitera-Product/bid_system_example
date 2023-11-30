class Feedback < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :answer
  # validations
  validates :content, presence: true
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
