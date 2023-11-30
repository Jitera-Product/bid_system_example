class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'match_id'
  # validations
  validates :content, presence: { message: "The content is required." }
  validates :user_id, presence: true
  validates :match_id, presence: true
end
