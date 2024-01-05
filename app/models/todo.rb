class Todo < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :todo_categories, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :attachments, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
  validates :priority, presence: true
  validates :recurring, inclusion: { in: [true, false] }
  validates :is_completed, inclusion: { in: [true, false] }
  validates :user_id, presence: true

  # Custom methods (if any)
end
