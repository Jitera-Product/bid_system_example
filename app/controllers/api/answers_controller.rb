class Api::AnswersController < ApplicationController
  before_action :set_question, only: [:show]
  def show
    @answer = Answer.find_by(question_id: @question.id)
    if @answer
      render json: { answer: @answer.content }
    else
      render json: { error: 'No answer found for this question' }, status: :not_found
    end
  end
  private
  def set_question
    @question = Question.find_by(id: params[:question_id])
    render json: { error: 'Question not found' }, status: :not_found unless @question
  end
end
