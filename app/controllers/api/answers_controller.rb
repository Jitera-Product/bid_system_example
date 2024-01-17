# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_user!

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
  end
end
