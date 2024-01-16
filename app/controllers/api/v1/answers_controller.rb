module Api
  module V1
    class AnswersController < ApplicationController
      include OauthTokensConcern
      before_action :doorkeeper_authorize!

      def create
        user = current_user
        content = params[:content]
        question_id = params[:question_id]

        begin
          answer_id = AnswerSubmissionService.new.submit_answer(content: content, question_id: question_id, user_id: user.id)
          render json: { answer_id: answer_id }, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

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

      # Add any custom methods below this line
    end
  end
end
