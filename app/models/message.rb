class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  # validations
  validates :content, presence: true
  validates :timestamp, presence: true
  validates :user_id, presence: true
  validates :match_id, presence: true
end
