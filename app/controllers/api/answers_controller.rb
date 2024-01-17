
# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_contributor!, only: [:create]
    before_action :authenticate_user!, except: [:create]

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
      answer = Answer.find(params[:answer_id])
      authorize(answer, :update?)

      raise ActiveRecord::RecordInvalid.new(answer) if params[:content].blank?

      updated_answer = AnswerService::Update.call(answer, params[:content])

      if updated_answer
        render json: { message: I18n.t('answers.update_success') }, status: :ok
      else
        render json: { message: I18n.t('common.422') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      base_render_unprocessable_entity(e)
    rescue Pundit::NotAuthorizedError => e
      base_render_unauthorized_error(e)
    end

    private

    def answer_params
      params.require(:answer).permit(:content, :question_id)
    end

    def validate_answer_submission(content, question_id)
      # Assuming this method exists to validate the answer submission
      # The actual implementation should be provided here
    end
  end
end
