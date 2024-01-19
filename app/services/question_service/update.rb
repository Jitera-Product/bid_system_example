module QuestionService
  class Update
    def call(id, content, contributor_id)
      question = Question.find_by(id: id, user_id: contributor_id)
      if question
        question.content = content
        question.save
      end
    end
  end
end
