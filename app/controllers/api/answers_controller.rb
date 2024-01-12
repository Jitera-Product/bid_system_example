class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!

  def index
    if params[:question].blank?
      render json: { message: "The question is required." }, status: :bad_request
      return
    end

    begin
      answers = AnswerService.new.retrieve_answers(params[:question])
      render json: { status: 200, answers: answers }, status: :ok
    rescue => e
      render json: error_response(nil, e), status: :internal_server_error
    end
  end

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
