class Question < ApplicationRecord
  # Existing associations
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  # Existing validations
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :category

  # New method to update question
  def update_question(title:, content:, category:, user_id:, tags: nil)
    ActiveRecord::Base.transaction do
      self.title = title
      self.content = content
      self.category = category
      self.updated_at = Time.current
      save!

      if tags
        question_tags.destroy_all
        tags.each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          question_tags.create!(tag: tag)
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    # Handle validation errors
    raise e
  end

  private

  # Helper method to get question tags
  def question_tags
    QuestionTag.where(question_id: self.id)
  end
end
