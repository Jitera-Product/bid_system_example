class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  validates :content, :feedback_type, presence: true, length: { maximum: 255 }
end
