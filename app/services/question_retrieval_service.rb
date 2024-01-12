
class QuestionRetrievalService
  include NlpParserService

  def retrieve_answers(query)
    terms = parse_query(query)
    questions = Question.joins(:tags).where('title LIKE :terms OR content LIKE :terms OR tags.name IN (:terms)', terms: terms)
    answers = Answer.where(question_id: questions.select(:id)).includes(:question)

    answers_ranked = answers.sort_by do |answer|
      relevance_score(answer, terms)
    end

    answers_ranked.map do |answer|
      { question_title: answer.question.title, question_content: answer.question.content, answer_content: answer.content }
    end
  end

  private

  # Existing code and methods...
end
