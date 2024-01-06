class Question < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # Validations
  validates :question_text, presence: true
  validates :user_id, presence: true

  # Add any additional methods below
end
