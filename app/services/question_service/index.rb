
class QuestionService::Index
  def initialize(params)
    @params = params
  end

  def find_similar_questions(nlp_data)
    intent = nlp_data[:intent]
    context = nlp_data[:context]

    Question.joins(:tags)
            .where('tags.name LIKE ?', "%#{context}%")
            .order('created_at DESC')
            .distinct
  end

  # ... other methods ...
end
