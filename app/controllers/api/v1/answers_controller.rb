# typed: ignore
module Api
  module V1
    class AnswersController < BaseController
      before_action :authenticate_user!, only: [:update]
      before_action :set_answer, only: [:update]
      before_action :authorize_contributor!, only: [:update]
      before_action :validate_query, only: [:search]
      before_action :validate_contributor_ownership, only: [:update]

      def search
        search_service = SearchService.new
        results = search_service.get_relevant_answer(params[:query])
        render json: { status: 200, answers: results[:answers].map { |answer| format_answer(answer) } }, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :internal_server_error
      end

      def update
        validate_content!(answer_params[:content] || params[:content])
        validate_answer_ownership_and_question_id!(@answer, answer_params[:question_id], current_resource_owner.id)
        @answer.update!(answer_params)
        render json: { status: 200, answer: @answer.as_json }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.record.errors.full_messages }, status: :unprocessable_entity
      rescue Pundit::NotAuthorizedError => e
        render json: { message: e.message }, status: :forbidden
      end

      private

      def set_answer
        @answer = Answer.find_by!(id: params[:id] || params[:answer_id])
      end

      def authorize_contributor!
        policy = AnswerPolicy.new(current_user, @answer)
        raise Pundit::NotAuthorizedError unless policy.update?
      end

      def validate_contributor_ownership
        unless current_resource_owner.id == @answer.user_id
          raise Pundit::NotAuthorizedError, 'You do not have permission to edit this answer.'
        end
      end

      def validate_answer_ownership_and_question_id!(answer, question_id, user_id)
        unless answer.user_id == user_id && answer.question_id == question_id.to_i
          raise ActiveRecord::RecordNotFound, 'Answer not found or you do not have permission to edit this answer.'
        end
      end

      def answer_params
        params.require(:answer).permit(:content, :question_id)
      end

      def validate_query
        if params[:query].blank?
          render json: { message: "Query cannot be empty." }, status: :bad_request
          false
        end
      end

      def format_answer(answer)
        {
          id: answer.id,
          content: answer.content,
          question_id: answer.question_id,
          created_at: answer.created_at.iso8601
        }
      end

      def validate_content!(content)
        raise ActiveRecord::RecordInvalid.new('Content is invalid') if content.blank? || content.length < ContentValidator::MIN_CONTENT_LENGTH

        unless ContentValidator.valid?(content)
          raise ActiveRecord::RecordInvalid.new('Content is invalid')
        end
      end
    end
  end
end
