# typed: ignore
class BaseService
  # Base service code here (if any)
end

class QuestionSubmissionService < BaseService
  def initialize(contributor_id, title, content, tags)
    @contributor_id = contributor_id
    @title = title
    @content = content
    @tags = tags
  end

  def call
    ActiveRecord::Base.transaction do
      contributor = User.find_by(id: @contributor_id, role: 'Contributor')
      raise StandardError.new("Contributor not found or not a Contributor") unless contributor

      raise StandardError.new("Title cannot be blank") if @title.blank?
      raise StandardError.new("Content cannot be blank") if @content.blank?

      tags = @tags.map do |tag_id|
        tag = Tag.find_by(id: tag_id)
        raise StandardError.new("Tag with id #{tag_id} does not exist") unless tag
        tag
      end

      question = Question.create!(user_id: @contributor_id, title: @title, content: @content)

      tags.each do |tag|
        QuestionTag.create!(question_id: question.id, tag_id: tag.id)
      end

      { question_id: question.id, title: question.title, content: question.content, tags: tags.map(&:name) }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end
end
