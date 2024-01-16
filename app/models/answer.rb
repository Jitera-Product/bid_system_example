class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :feedbacks, dependent: :destroy

  # validations
  validates :content, presence: true
  validates :question_id, presence: true

  # Retrieve associated answers for a given question
  def self.retrieve_associated_answers(question)
    question.answers
  end

  # Update the moderation status of the answer
  def update_moderation_status(action)
    case action
    when 'approve'
      update!(status: 'approved')
    when 'reject'
      update!(status: 'rejected')
    end
  end

  # Add any custom methods below if required
end
