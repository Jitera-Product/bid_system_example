
class QuestionRetrievalService
  # Existing methods...

  def find_similar_questions(nlp_data)
    intent = nlp_data[:intent]
    context = nlp_data[:context]

    # Assuming 'question_text' is the column to perform full-text search on
    # and 'intent' and 'context' are used to refine the search.
    # This is a simple example using basic ActiveRecord querying methods.
    # Depending on the database used, you might need to use specific full-text search features.
    Question.where('question_text LIKE ?', "%#{intent}%")
            .or(Question.where('question_text LIKE ?', "%#{context}%"))
            .limit(10) # Limiting the result for the sake of performance
  end

end
