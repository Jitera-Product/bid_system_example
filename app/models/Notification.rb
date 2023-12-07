class Notification < ApplicationRecord
  # associations
  belongs_to :user

  # validations
  validates :content, presence: true
  validates :user_id, presence: true

  # methods
  # Add any custom methods for Notification model here
end
