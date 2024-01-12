class Question < ApplicationRecord
  # Existing associations
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  # Existing validations
  validates :title, presence: true, length: { maximum: 200 }
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
        current_tags = self.tags.pluck(:id)
        new_tags = tags - current_tags
        old_tags = current_tags - tags

        # Remove old tags associations
        self.tags.delete(Tag.where(id: old_tags)) unless old_tags.empty?

        # Add new tags associations
        new_tags.each { |tag_id| self.tags << Tag.find(tag_id) } unless new_tags.empty?
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
