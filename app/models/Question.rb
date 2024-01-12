class Question < ApplicationRecord
  # associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy

  # validations
  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

  # custom methods
end
