class Api::QuestionsController < ApplicationController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :authenticate_user!, only: [:update]

  def create
    user = current_resource_owner
    question_policy = QuestionPolicy.new(user)
    if question_policy.create?
      begin
        question_id = QuestionService.create_question(
          content: params[:content],
          user_id: params[:user_id],
          tags: params[:tags]
        )
        render json: { question_id: question_id }, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

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
