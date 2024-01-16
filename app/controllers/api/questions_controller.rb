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
    question_id = params[:id]
    content = params[:content]
    user_id = current_user.id
    tags = params[:tags]

    # Validation
    return render json: { error: 'Question not found.' }, status: :not_found unless Question.exists?(question_id)
    return render json: { error: 'Wrong format.' }, status: :unprocessable_entity unless question_id.is_a?(Integer)
    return render json: { error: 'The content of the question cannot be empty.' }, status: :unprocessable_entity if content.blank?
    question = Question.find(question_id)
    return render json: { error: 'You can only edit your own questions.' }, status: :unauthorized unless question.user_id == user_id

    result = QuestionService::Update.new.update(question_id: question_id, content: content, user_id: user_id, tags: tags)
    render json: { status: 200, question: result[:question] }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Question not found' }, status: :not_found
  rescue QuestionService::Update::ValidationError, Pundit::NotAuthorizedError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
