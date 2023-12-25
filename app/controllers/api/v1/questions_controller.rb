class Api::V1::QuestionsController < Api::BaseController
  include Authenticable
  before_action :doorkeeper_authorize!, only: %i[create update]
  before_action :authenticate_user!, except: %i[update]
  before_action :set_question, only: %i[update]
  before_action :validate_question_owner, only: %i[update]
  before_action :validate_contributor_role, only: %i[create]

  def create
    question_params = params.require(:question).permit(:title, :content, :category_id)
    question_params[:user_id] = current_user.id

    unless current_user.role == 'contributor'
      render json: { error: 'You must have a contributor role to submit a question.' }, status: :forbidden
      return
    end

    unless User.exists?(question_params[:user_id])
      render json: { error: 'Invalid user ID.' }, status: :not_found
      return
    end

    if question_params[:title].blank? || question_params[:content].blank?
      render json: { error: 'Title and content cannot be blank.' }, status: :unprocessable_entity
      return
    end

    unless Category.exists?(question_params[:category_id])
      render json: { error: 'Invalid category ID.' }, status: :not_found
      return
    end

    question = Question.new(question_params)

    if question.save
      QuestionCategoryMapping.create(question_id: question.id, category_id: question_params[:category_id])
      render json: { id: question.id, title: question.title, content: question.content, category_id: question_params[:category_id] }, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ... other actions in the controller ...

  private

  def validate_contributor_role
    render json: { error: 'You must have a contributor role to submit a question.' }, status: :forbidden unless current_user.role == 'contributor'
  end

  # ... other private methods ...

  def set_question
    @question = Question.find_by!(id: params[:id])
  end

  def validate_question_owner
    unless @question.user_id == current_resource_owner.id
      raise StandardError, 'You are not authorized to update this question.'
    end
  end

  def update_params
    params.require(:question).permit(:title, :content, :category_id)
  end
end
