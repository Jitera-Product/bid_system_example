class ModerationQueue < ApplicationRecord
  # Assuming that the content is polymorphic, we need to specify the polymorphic association
  belongs_to :content, polymorphic: true

  # Enum for status, assuming there are predefined statuses
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # Validations
  validates :content_id, presence: true
  validates :content_type, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
end
