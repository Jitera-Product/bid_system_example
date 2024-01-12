
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  # ... other associations and code ...
end
