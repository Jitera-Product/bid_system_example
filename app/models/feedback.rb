
class Feedback < ApplicationRecord
  # validations
  validates :usefulness, presence: true
  validates_inclusion_of :usefulness, in: ['very_useful', 'useful', 'not_useful']
  validates :comment, length: { maximum: 500 }

  # associations
  belongs_to :answer
  belongs_to :user

  # callbacks
  after_create :adjust_ai_responses
  after_save :update_answer_feedback_score, if: :saved_change_to_usefulness?

  private

  def adjust_ai_responses
    # Logic to adjust AI's future responses goes here
  end

  def update_answer_feedback_score
    # Logic to update the associated answer's feedback score goes here
  end
end
