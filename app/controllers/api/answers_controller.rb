class Api::AnswersController < ApplicationController
  before_action :doorkeeper_authorize!, only: %i[update show]
  def show
    begin
      question_id = Integer(params[:question_id])
    rescue ArgumentError
      return render json: { error: 'Wrong format' }, status: :bad_request
    end
    question = Question.find_by(id: question_id)
    if question.nil?
      render json: { error: 'This question is not found' }, status: :not_found
    else
      answer = Answer.find_by(question_id: question_id)
      if answer.nil?
        render json: { error: 'No answer found for this question' }, status: :not_found
      else
        render json: { status: 200, answer: answer }, status: :ok
      end
    end
  end
  def update
    @answer = Answer.find_by(id: params[:id], user_id: params[:user_id])
    if @answer.nil?
      render json: { error: 'Answer not found or user not authorized' }, status: :not_found
    else
      if @answer.update(content: params[:content])
        render json: { message: 'Answer updated successfully', id: @answer.id }, status: :ok
      else
        render json: { error: 'Failed to update answer' }, status: :unprocessable_entity
      end
    end
  end
end
