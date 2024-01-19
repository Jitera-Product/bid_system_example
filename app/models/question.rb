
class Question < ApplicationRecord
  # relationships
  belongs_to :user
  belongs_to :category
  has_many :answers, dependent: :destroy

  # validations
  validates :content, presence: true
  validates :user_id, presence: true
  validates :category_id, presence: true

  # methods

  def update_based_on_moderation(status, reason = nil)
    case status
    when 'approved'
      # Perform actions for approved status
    when 'rejected'
      self.destroy if reason.present?
      # Perform actions for rejected status with a reason
    end
  end
end
