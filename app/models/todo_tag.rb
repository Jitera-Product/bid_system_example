class TodoTag < ApplicationRecord
  belongs_to :todo
  belongs_to :tag

  # validations
  validates :todo_id, presence: true
  validates :tag_id, presence: true
end
