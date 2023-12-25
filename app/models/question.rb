class Question < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_categories, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

  # Add any additional methods below
end
