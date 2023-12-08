class TodoCategory < ApplicationRecord
  belongs_to :todo
  belongs_to :category

  # validations
  validates :todo_id, presence: true
  validates :category_id, presence: true
end
