# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_contributor!, only: [:create]
    before_action :authenticate_user!, except: [:create]
    before_action :set_answer, only: [:update]
    before_action :authorize_answer, only: [:update]

    def create
      if validate_answer_submission(params[:content], params[:question_id])
        answer = Answer.new(answer_params.merge(user_id: current_user.id))

        if answer.save
          render json: { answer_id: answer.id }, status: :created
        else
          render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end

    def update
      raise ActiveRecord::RecordInvalid.new(@answer) if params[:content].blank?

      if @answer.update(content: params[:content])
        render json: {
          status: 200,
          answer: {
            id: @answer.id,
            content: @answer.content,
            question_id: @answer.question_id,
            updated_at: @answer.updated_at
          }
        }, status: :ok
      else
        render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :bad_request
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :unauthorized
    end

    private

    def set_answer
      @answer = Answer.find_by(id: params[:id])
      render json: { error: 'Answer not found.' }, status: :not_found unless @answer
    end

    def authorize_answer
      render json: { error: 'You do not have permission to edit this answer.' }, status: :unauthorized unless @answer.user_id == current_user.id
    end

    def answer_params
      params.require(:answer).permit(:content, :question_id)
    end

    def validate_answer_submission(content, question_id)
      # Assuming this method exists to validate the answer submission
      # The actual implementation should be provided here
    end
  end
end
