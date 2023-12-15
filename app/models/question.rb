class Question < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :question_categories, dependent: :destroy # Added new relationship

  # Validations
  validates :content, presence: true
  validates :user_id, presence: true

  # Custom methods
  # Define any custom methods that the model might require here
end
