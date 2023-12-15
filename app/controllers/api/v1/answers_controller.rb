# typed: ignore
module Api
  module V1
    class AnswersController < BaseController
      before_action :authenticate_user!, only: [:update]
      before_action :set_answer, only: [:update]
      before_action :authorize_contributor!, only: [:update]

      def update
        validate_content!(answer_params[:content])
        if @answer.update(answer_params)
          render json: { status: 200, answer: @answer.as_json }, status: :ok
        else
          render json: { message: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound => e
        base_render_record_not_found(e)
      rescue Pundit::NotAuthorizedError => e
        base_render_unauthorized_error(e)
      rescue Exceptions::AuthenticationError => e
        base_render_unauthorized_error(e)
      end

      private

      def set_answer
        @answer = Answer.find_by(id: params[:id])
        base_render_record_not_found('Answer not found or you do not have permission to edit this answer.') unless @answer
      end

      def authorize_contributor!
        unless current_resource_owner.id == @answer.question.contributor_id
          base_render_unauthorized_error('Answer not found or you do not have permission to edit this answer.')
        end
      end

      def answer_params
        params.require(:answer).permit(:content)
      end

      def validate_content!(content)
        if content.blank?
          render json: { message: 'Answer content cannot be empty.' }, status: :unprocessable_entity
          return false
        end
        true
      end
    end
  end
end
