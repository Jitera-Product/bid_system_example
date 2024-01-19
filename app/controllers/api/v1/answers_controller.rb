
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

end
