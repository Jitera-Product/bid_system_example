
class Api::QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def update
    question_id = params[:question_id]
    content = params[:content]
    user_id = current_user.id
    tags = params[:tags]
    result = QuestionService::Update.new.update(question_id: question_id, content: content, user_id: user_id, tags: tags)
    render json: { message: result[:message] }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Question not found' }, status: :not_found
  rescue QuestionService::Update::ValidationError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
