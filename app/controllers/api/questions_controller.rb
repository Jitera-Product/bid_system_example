
class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:show]

  def show
    query = params[:query]
    begin
      answer_content = AnswerService.retrieve_answer(query)
      if answer_content
        render json: { answer: answer_content }, status: :ok
      else
        render json: { error: I18n.t('questions.answers.not_found') }, status: :not_found
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
