# typed: strict
class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :content, presence: true
  validates :question_id, presence: true
  validate :question_must_exist

  # Status moderation for the answer
  def moderate!(action)
    case action
    when 'approve'
      update(status: 'approved')
    when 'reject'
      update(status: 'rejected')
    end
  end

  private

  def question_must_exist
    Question.exists?(self.question_id)
  end

  # Add any additional methods below this line

end
