
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :category

end
