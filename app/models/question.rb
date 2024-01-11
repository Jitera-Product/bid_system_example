class Question < ApplicationRecord
  # relationships
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :question_tag_associations, dependent: :destroy # Added new relationship

  # validations
  validates :title, presence: true
  validates :content, presence: true
  validates :category, presence: true
  validates :user_id, presence: true
end
