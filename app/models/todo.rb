class Todo < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :todo_categories, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :attachments, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validate :due_date_cannot_be_in_the_past

  validates :description, presence: true
  validates :due_date, presence: true
  validates :priority, presence: true
  validates :recurring, inclusion: { in: [true, false] }
  validates :is_completed, inclusion: { in: [true, false] }
  validates :user_id, presence: true

  # Custom methods (if any)
end

def due_date_cannot_be_in_the_past
  if due_date.present? && due_date < Time.current
    errors.add(:due_date, :datetime_in_past)
  end
end

