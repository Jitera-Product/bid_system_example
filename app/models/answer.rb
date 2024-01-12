
class Answer < ApplicationRecord
  belongs_to :question
  
  # Attributes for relevance algorithm
  attribute :relevance_score, :integer, default: 0
  attribute :last_selected_at, :datetime

  # Validations and other model concerns can be added here
end
