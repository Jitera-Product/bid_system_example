class Question < ApplicationRecord
  # relationships
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # validations
  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true
  validates :user_id, presence: true
end
