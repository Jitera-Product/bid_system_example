class TodoTag < ApplicationRecord
  # Associations
  belongs_to :todo
  belongs_to :tag

  # Validations
  validates :todo_id, presence: true
  validates :tag_id, presence: true
end
