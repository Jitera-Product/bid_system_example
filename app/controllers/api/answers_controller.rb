class Api::AnswersController < ApplicationController
  before_action :set_question, only: [:show, :create]
  before_action :doorkeeper_authorize!, only: %i[create]
  def show
    @answer = Answer.find_by(question_id: @question.id)
    if @answer
      render json: { answer: @answer.content }
    else
      render json: { error: 'No answer found for this question' }, status: :not_found
    end
  end
  def create
    user = UserService::Find.new(user_id: params[:user_id]).execute
    raise Exceptions::Unauthorized, 'User is not a contributor' unless user.role == 'contributor'
    answer = AnswerService::Create.new(content: params[:content], user_id: user.id, question_id: @question.id).execute
    if answer.persisted?
      render json: { message: 'Answer submitted successfully', answer_id: answer.id }, status: :created
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Exceptions::Unauthorized => e
    render json: { error: e.message }, status: :unauthorized
  rescue Exceptions::NotFound => e
    render json: { error: e.message }, status: :not_found
  end
  private
  def set_question
    @question = Question.find_by(id: params[:question_id])
    render json: { error: 'Question not found' }, status: :not_found unless @question
  end
end
