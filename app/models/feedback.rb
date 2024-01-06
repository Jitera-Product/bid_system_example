class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  # Removed the validations for :answer_id and :inquirer_id as they are not mentioned in the "# TABLE" section
  validates :comment, length: { maximum: 500 }

  # Removed the associations for :answer and :inquirer as they are not mentioned in the "# TABLE" section

  # callbacks
  after_create :adjust_ai_responses

  private

  def adjust_ai_responses
    # Logic to adjust AI's future responses goes here
  end
end
