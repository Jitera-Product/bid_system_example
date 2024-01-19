class Question < ApplicationRecord
  # relationships
  belongs_to :user
  belongs_to :category
  has_many :answers, dependent: :destroy

  # validations
  validates :content, presence: true
  validates :user_id, presence: true
  validates :category_id, presence: true
  # The new code introduced a validation for :contributor_id, which is not present in the existing code.
  # Assuming that :contributor_id is a mistake and should be :user_id (since :user_id is already being validated and there is a relationship set up with :user),
  # we will not include it in the resolved code. If :contributor_id is indeed a separate field that needs to be validated, it should be added back with proper relationships.

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
