class Api::V1::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create update destroy]

  def retrieve_answer
    content = params.require(:content)
    question_ids = QuestionRetrievalService.new.parse_and_search_questions(content)
    answers = AnswerRankingService.new.rank_and_retrieve_answers(question_ids, content)

    if answers.present?
      render json: { answers: answers, total: answers.size }, status: :ok
    else
      render json: { error: 'No relevant answers found.' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def search
    query = params[:query].presence || (render json: { error: 'The search query is required.' }, status: :bad_request and return)
    validation_result = QuestionValidator.new.validate_content(query)

    if validation_result.is_a?(Hash)
      render json: { error: validation_result[:error] }, status: :unprocessable_entity
    else
      question_ids = QuestionRetrievalService.new.parse_and_search_questions(query)
      answers = AnswerRankingService.new.rank_and_retrieve_answers(question_ids, query)

      if answers.any?
        render json: { status: 200, answers: answers }, status: :ok
      else
        render json: { error: 'No answers found for the given query.' }, status: :not_found
      end
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
