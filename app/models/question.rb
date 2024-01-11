
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

  # callbacks
  after_create :associate_tags, if: -> { @tag_ids.present? }

  # temporary accessor for tag ids
  attr_accessor :tag_ids

  private

  def associate_tags
    tag_ids.each do |tag_id|
      question_tags.create(tag_id: tag_id)
    end
  end
end
