# typed: true
class QuestionService < BaseService
  def create_question(content, user_id, tags)
    QuestionValidator.new.validate(content, tags)
    question = Question.create!(content: content, user_id: user_id)
    tags.each do |tag_id|
      QuestionTag.create!(question_id: question.id, tag_id: tag_id)
    end
    question.id
  rescue => e
    logger.error "QuestionService#create_question error: #{e.message}"
    raise e
  end
end
