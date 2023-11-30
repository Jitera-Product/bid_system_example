class Api::AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]
  def index
    @answers = Answer.all
    render json: @answers
  end
  def show
    render json: @answer
  end
  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      render json: @answer, status: :created, location: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end
  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @answer.destroy
  end
  def retrieve_answer
    query = params[:content]
    keywords = query.downcase.split(' ')
    answers = Answer.where('content LIKE ?', "%#{keywords.join('%')}%")
    answer = answers.order(created_at: :desc).first
    if answer
      render json: {answer: answer.content, question_id: answer.question_id, answer_id: answer.id}
    else
      render json: {error: 'No relevant answer found'}, status: :not_found
    end
  end
  private
  def set_answer
    @answer = Answer.find(params[:id])
  end
  def answer_params
    params.require(:answer).permit(:content, :user_id, :question_id)
  end
end
