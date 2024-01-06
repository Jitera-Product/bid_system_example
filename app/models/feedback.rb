
class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates :answer_id, presence: true
  validates :inquirer_id, presence: true
  validates :comment, length: { maximum: 500 }

  # associations
  belongs_to :answer
  belongs_to :inquirer, class_name: 'User'

  # callbacks
  after_create :adjust_ai_responses

  private

  def adjust_ai_responses
    # Logic to adjust AI's future responses goes here
  end
end
