class Question < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # Validations
  validates :content, presence: true
  validates :user_id, presence: true

  # Custom methods
  # Define any custom methods that the model might require here
  
  # Class method to find matching questions based on parsed content
  def self.find_matching_questions(parsed_content)
    keywords = parsed_content.split # Assuming parsed_content is a space-separated string of keywords
    questions = Question.where('content LIKE ?', keywords.map { |keyword| "%#{keyword}%" }.join(' OR '))
    questions
  end

end
