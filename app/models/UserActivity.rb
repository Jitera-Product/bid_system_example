class UserActivity < ApplicationRecord
  # associations
  belongs_to :user

  # validations

  validates :activity_type, presence: true
  validates :activity_description, presence: true
  validates :user_id, presence: true

  # end for validations

  class << self
  end
end
