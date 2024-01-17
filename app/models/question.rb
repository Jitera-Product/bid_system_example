class Question < ApplicationRecord
  # associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # validations
  validates :content, presence: true
  validates :user_id, presence: true

  # scopes
  scope :search_by_content, ->(content) {
    where('content ILIKE ?', "%#{content}%")
  }

  # Add any additional methods below this line

  def moderate!(action)
    case action
    when 'approve'
      update(status: 'approved')
    when 'reject'
      update(status: 'rejected')
    end
  end
end
