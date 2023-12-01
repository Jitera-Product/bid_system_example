class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :feedbacks, dependent: :destroy
  validates :content, presence: true
end
