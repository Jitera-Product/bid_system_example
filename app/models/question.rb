class Question < ApplicationRecord
  # Validations
  validates :title, presence: { message: I18n.t('activerecord.errors.messages.blank') }, on: :update
  validates :content, presence: { message: I18n.t('activerecord.errors.messages.blank') }, on: :update

  # Associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :question_tags # Assuming this association is needed for the new code

  # ... other associations and methods ...

  # New method to create question with tags
  def self.create_with_tags(contributor_id:, title:, content:, tag_ids:)
    question = create(user_id: contributor_id, title: title, content: content)
    tag_ids.each do |tag_id|
      QuestionTag.create(question_id: question.id, tag_id: tag_id)
    end
    question.id
  end

  # ... other methods ...
end
