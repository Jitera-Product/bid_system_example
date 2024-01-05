class TodoCategory < ApplicationRecord
  # Associations
  belongs_to :todo
  belongs_to :category

  # Validations
  validates :todo_id, presence: true
  validates :category_id, presence: true
end
