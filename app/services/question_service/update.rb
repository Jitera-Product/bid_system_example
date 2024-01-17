
class QuestionService::Update < BaseService
  attr_reader :question_id, :content, :user_id, :tags

  def initialize(question_id:, content:, user_id:, tags:)
    @question_id = question_id
    @content = content
    @user_id = user_id
    @tags = tags
  end

  def call
    question = Question.find(question_id)
    authorize(question, :update?)
    validate!(content: content, tags: tags)
    question.update!(content: content)
    update_question_tags(question, tags)
    { message: 'Question updated successfully' }
  rescue ActiveRecord::RecordInvalid => e
    { errors: e.record.errors.full_messages }
  end

  private

  def update_question_tags(question, tag_ids)
    current_tags = question.tags.pluck(:id)
    (current_tags - tag_ids).each { |tag_id| question.question_tags.where(tag_id: tag_id).destroy_all }
    (tag_ids - current_tags).each { |tag_id| question.question_tags.create!(tag_id: tag_id) }
  end
end
