class SearchService
  # Existing methods...

  # New method to search answers based on a query string
  def search_answers(query)
    # Use NlpService to parse the query and extract key terms
    key_terms = NlpService.parse_query(query)

    # Find relevant content from Question and Answer models
    results = find_relevant_content(key_terms)

    # Rank the results based on relevance
    ranked_results = rank_results(results)

    # Select the most relevant answer
    most_relevant_answer = ranked_results.first

    # Retrieve the corresponding content, question title, and associated tags
    answer_content = most_relevant_answer.content
    question_title = most_relevant_answer.question.title
    associated_tags = most_relevant_answer.question.tags.map(&:name)

    # Log the query and the answer provided
    LogService.log_query_and_answer(query, most_relevant_answer)

    # Return the answer content, question title, and associated tags
    { answer_content: answer_content, question_title: question_title, tags: associated_tags }
  end

  private

  # Method to find relevant content based on key terms
  def find_relevant_content(key_terms)
    # Assuming the existence of a scope or class method `search_by_terms` on Question and Answer models
    questions = Question.search_by_terms(key_terms)
    answers = Answer.search_by_terms(key_terms)

    # Combine and return both results
    questions + answers
  end

  # Method to rank results based on relevance
  def rank_results(results)
    # Assuming the existence of a method `calculate_relevance_score` for each result
    results.sort_by { |result| -result.calculate_relevance_score }
  end
end
