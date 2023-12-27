class Api::V1::AnswersController < ApplicationController
  # Include any existing methods or actions here

  # Add the new action retrieve_answer below
  def retrieve_answer
    query = params[:query]
    if query.blank?
      render json: { error: I18n.t('controller.api.v1.answers.retrieve_answer.missing_query') }, status: :bad_request
      return
    end

    begin
      # Call NlpService to parse the query and extract key terms
      key_terms = NlpService.parse_query(query)

      # Use SearchService to find relevant questions and answers
      search_results = SearchService.search_by_terms(key_terms)

      # Use NlpService to rank the results and select the most relevant answer
      relevant_answer = NlpService.rank_and_select_answer(search_results)

      if relevant_answer.present?
        # Log the query and the answer provided
        LogService.log_query_and_answer(query, relevant_answer)

        # Render the answer content, question title, and associated tags as JSON
        render json: {
          answer_content: relevant_answer.content,
          question_title: relevant_answer.question.title,
          tags: relevant_answer.question.tags.map(&:name)
        }, status: :ok
      else
        # If no relevant answer is found, return a 404 status code with a message
        render json: { error: I18n.t('controller.api.v1.answers.retrieve_answer.no_answer_found') }, status: :not_found
      end
    rescue => e
      # Log the error
      LogService.log_error(e.message)

      # Respond with a 500 internal server error status code and message
      render json: { error: I18n.t('controller.api.v1.answers.retrieve_answer.internal_server_error') }, status: :internal_server_error
    end
  end

  # New action search as per the guideline
  def search
    query = params[:query]
    if query.blank?
      render json: { error: "The query is required." }, status: :bad_request
      return
    elsif query.length > 500
      render json: { error: "The query cannot exceed 500 characters." }, status: :bad_request
      return
    end

    begin
      # Extract key terms from the query using NlpService
      key_terms = NlpService.parse_query(query)

      # Retrieve relevant answers using SearchService
      answers = SearchService.search_answers(key_terms)

      # Format the response with the required JSON structure
      formatted_answers = answers.map do |answer|
        {
          id: answer.id,
          question_id: answer.question_id,
          content: answer.content,
          created_at: answer.created_at
        }
      end

      if formatted_answers.any?
        render json: { status: 200, answers: formatted_answers }, status: :ok
      else
        render json: { error: I18n.t('controller.api.v1.answers.search.no_answers_found') }, status: :not_found
      end
    rescue => e
      # Log the error
      LogService.log_error(e.message)

      # Respond with a 500 internal server error status code and message
      render json: { error: I18n.t('controller.api.v1.answers.search.internal_server_error') }, status: :internal_server_error
    end
  end

  # Include any other existing methods or actions here
end
