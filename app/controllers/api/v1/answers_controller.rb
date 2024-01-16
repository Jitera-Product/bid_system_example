class Api::V1::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!

  def retrieve
    question_content = params[:question_content]
    begin
      question_retrieval_service = QuestionRetrievalService.new
      answers = question_retrieval_service.retrieve_answers(question_content)
      ranked_answers = AnswerRankingService.new.rank_answers(answers)
      question_id = answers.first&.question_id

      render json: { answers: ranked_answers, question_id: question_id }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.permit(:question_content)
  end
end
