class UserActivity < ApplicationRecord
  # associations
  belongs_to :user

  # validations

  validates :activity_type, presence: true
  validates :activity_description, presence: true
  validates :user_id, presence: true
  validates :action, presence: true  # Assuming 'action' is a new column to be validated
  validates :timestamp, presence: true  # Assuming 'timestamp' is a new column to be validated

  # end for validations

  class << self
  end
end
