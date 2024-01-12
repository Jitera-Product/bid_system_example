class QuestionTag < ApplicationRecord
  # Define the table name if it's not the pluralized form of the model name
  # In this case, it's not necessary as Rails will automatically infer the table name

  # Associations
  belongs_to :question
  belongs_to :tag

  # Validations
  validates :question_id, presence: true
  validates :tag_id, presence: true

  # Custom methods
  # Define any custom methods that might be necessary for the QuestionTag model
end
