class Match < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  # validations
  validates :compatibility_score, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
end
