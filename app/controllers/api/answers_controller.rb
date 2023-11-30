class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[show]
  before_action :set_question, only: [:show]
  def show
    @answer = @question.answers.first
    if @answer
      render json: {status: 200, answer: @answer}, status: :ok
    else
      render json: {error: "Answer not found"}, status: :not_found
    end
  end
  private
  def set_question
    if params[:question_id].to_i.to_s != params[:question_id]
      render json: {error: "Wrong format"}, status: :unprocessable_entity
    else
      @question = Question.find_by(id: params[:question_id])
      render json: {error: "This question is not found"}, status: :not_found unless @question
    end
  end
end
