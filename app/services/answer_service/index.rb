require 'nlp_parser_service'

class AnswerService
  def retrieve_answers(query)
    parsed_query = NlpParserService.parse(query)
    relevant_questions = Question.joins(:question_tags => :tag)
                                 .where('title LIKE :query OR content LIKE :query OR tags.name IN (:tags)',
                                        query: "%#{parsed_query[:keywords].join('%')}%",
                                        tags: parsed_query[:tags])
                                 .distinct

    relevant_answers = Answer.where(question_id: relevant_questions.select(:id))
                             .joins(:question)
                             .select('answers.content, questions.title, questions.content as question_content')

    # Log the query and answers for future analysis
    log_query_and_answers(query, relevant_answers)

    relevant_answers.map do |answer|
      {
        answer_content: answer.content,
        question_title: answer.title,
        question_content: answer.question_content
      }
    end
  end

  private

  def log_query_and_answers(query, answers)
    # Implementation for logging queries and answers
    # This method should be implemented to log the query and the answers for future analysis
    # For example, it could log to a file, database, or an analytics service
  end
end
