
class AnswerService
  class Index
    def retrieve_answers_for_questions(questions)
      question_ids = questions.map(&:id)
      Answer.includes(:question)
            .where(question_id: question_ids)
            .group_by(&:question_id)
    end

    # ... other methods ...
  end
end
