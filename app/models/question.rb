class Question < ApplicationRecord
  # associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  # validations
  validates :content, presence: true, message: "Question content cannot be empty."
  validates :user_id, presence: true
  validate :user_must_exist
  validate :tags_must_exist, if: -> { tags.present? }

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

  private

  def user_must_exist
    errors.add(:user_id, "User not found.") unless User.exists?(self.user_id)
  end

  def tags_must_exist
    tag_ids = Tag.pluck(:id)
    invalid_tags = self.tags.map(&:id) - tag_ids
    errors.add(:tags, "One or more tags are invalid.") if invalid_tags.any?
  end
end
