class SearchService
  # Existing methods (if any)...

  # Implement a method `parse_query` that takes a string input "query" and uses natural language processing (NLP) techniques to extract key terms and intent.
  def parse_query(query)
    query.split(/\W+/)
  end

  # Create a method `search_questions` that takes the parsed terms as input and searches the 'questions' table for matches.
  def search_questions(terms)
    Question.where('content LIKE ?', terms.map { |term| "%#{term}%" })
  end

  # Add a method `select_relevant_questions` that takes the search results as input and selects the most relevant question(s).
  def select_relevant_questions(questions)
    questions.order(created_at: :desc).limit(5)
  end

  # Implement a method `retrieve_answers` that takes the relevant `Question` objects as input and retrieves the corresponding `Answer` objects.
  def retrieve_answers(questions)
    Answer.where(question_id: questions.pluck(:id))
  end

  # If multiple answers are retrieved, add a method `rank_answers` that applies a relevance algorithm to rank the answers.
  def rank_answers(answers, terms)
    answers.sort_by do |answer|
      term_matches = terms.count { |term| answer.content.include?(term) }
      feedback_score = answer.feedbacks.average(:rating) || 0
      term_matches + feedback_score
    end.reverse
  end

  # The main method `get_relevant_answer` should orchestrate the flow described in the requirement.
  def get_relevant_answer(query)
    terms = parse_query(query)
    questions = search_questions(terms)
    relevant_questions = select_relevant_questions(questions)
    answers = retrieve_answers(relevant_questions)
    ranked_answers = rank_answers(answers, terms)

    {
      answers: ranked_answers.map(&:content),
      question_ids: ranked_answers.map(&:question_id)
    }
  end

  # New method `search_answers_for_query` as per the guideline
  def search_answers_for_query(query)
    terms = parse_query(query)
    questions = search_questions(terms)
    relevant_questions = select_relevant_questions(questions)
    answers = retrieve_answers(relevant_questions)
    ranked_answers = rank_answers(answers, terms)

    ranked_answers.map do |answer|
      {
        content: answer.content,
        question: {
          id: answer.question_id,
          content: Question.find(answer.question_id).content
        }
      }
    end
  end
end
