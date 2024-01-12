
class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!

  def update
    answer_id = params[:id]
    contributor_id = params[:contributor_id]
    content = params[:content]

    answer = AnswerService.find(answer_id)
    authorize AnswerPolicy.new(current_user, answer), :edit?

    if content.blank?
      render json: { message: I18n.t('activerecord.errors.messages.blank') }, status: :unprocessable_entity
      return
    end

    updated_answer = AnswerService.update(answer, content)
    render json: { message: I18n.t('common.200'), answer: updated_answer }, status: :ok
  end
end
