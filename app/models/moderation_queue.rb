class ModerationQueue < ApplicationRecord
  # relationships
  # Add any necessary relationships here. For example, if a moderation queue belongs to a user:
  # belongs_to :user

  # validations
  validates :content_type, presence: true
  validates :status, presence: true
  validates :reason, presence: true

  # Add any additional validations here. For example, if status has a set of allowed values:
  # validates :status, inclusion: { in: %w[pending approved rejected] }

  # Add any additional callbacks here. For example, if you want to set a default status:
  # before_validation :set_default_status, on: :create

  private

  # def set_default_status
  #   self.status ||= 'pending'
  # end
end
