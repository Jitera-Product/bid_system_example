
class Api::V1::AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:retrieve_answer]

  # GET /api/v1/answers/retrieve
  def retrieve_answer
    begin
      query = params[:query]
      raise ArgumentError, 'Query parameter is missing' if query.blank?

      parsed_query = NlpParserService.parse(query)
      matching_questions = QuestionMatchingService.find_matching_questions(parsed_query)
      answer = AnswerSelectionService.select_best_answer(matching_questions)

      if answer
        render json: { answer_id: answer.id, answer_content: answer.content }, status: :ok
      else
        render json: { error: 'No matching answer found' }, status: :not_found
      end
    rescue Exceptions::AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user!
    # Authentication logic here, raise Exceptions::AuthenticationError if failed
  end
end
