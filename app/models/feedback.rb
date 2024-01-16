
class Feedback < ApplicationRecord
  enum usefulness: {
    very_useful: 'very_useful',
    useful: 'useful',
    not_useful: 'not_useful'
  }
   
  # validations
  validates :comment, presence: true
end
