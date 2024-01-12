
class QuestionService
  def submit_question(contributor_id:, title:, content:, tags:)
    question_valid = QuestionValidator.new(title: title, content: content)
    tag_valid = TagValidator.new(tag_ids: tags)

    if question_valid.valid? && tag_valid.valid?
      question = Question.create!(user_id: contributor_id, title: title, content: content)
      tags.each do |tag_id|
        QuestionTag.create!(question_id: question.id, tag_id: tag_id)
      end
      question.id
    else
      raise StandardError.new("Invalid question or tags")
    end
  end
end
