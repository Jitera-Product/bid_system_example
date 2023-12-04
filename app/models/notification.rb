class Notification < ApplicationRecord
  belongs_to :user
  # validations
  validates :activity_type, presence: true
  validates :details, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  validates :id, numericality: { only_integer: true, message: "Wrong format." }
end
