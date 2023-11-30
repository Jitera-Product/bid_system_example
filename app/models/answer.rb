class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :feedbacks, dependent: :destroy
  validates :content, presence: true
  # Add any other validations, methods, or associations specific to the 'answers' table here
end
