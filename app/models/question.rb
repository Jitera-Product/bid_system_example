class Question < ApplicationRecord
  # relationships
  belongs_to :user
  belongs_to :category
  has_many :answers, dependent: :destroy

  # validations
  validates :content, presence: true
  validates :user_id, presence: true
  validates :category_id, presence: true
end
