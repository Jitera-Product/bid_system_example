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

    if question_params[:title].blank?
      render json: { error: 'The title is required.' }, status: :unprocessable_entity
      return
    end

    if question_params[:content].blank?
      render json: { error: 'The content is required.' }, status: :unprocessable_entity
      return
    end

    unless User.exists?(question_params[:user_id])
      render json: { error: 'User not found.' }, status: :not_found
      return
    end

    unless Category.exists?(question_params[:category_id])
      render json: { error: 'Category not found.' }, status: :not_found
      return
    end

    question = Question.new(question_params)

    if question.save
      render json: { status: 201, question: question.as_json.merge(created_at: question.created_at.iso8601) }, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # ... other actions in the controller ...

  private

  def validate_contributor_role
    render json: { error: 'You must have a contributor role to submit a question.' }, status: :forbidden unless current_user.role == 'contributor'
  end

  def set_question
    @question = Question.find_by!(id: params[:id])
  end

  def validate_question_owner
    unless @question.user_id == current_resource_owner.id
      render json: { error: 'You are not authorized to update this question.' }, status: :forbidden
    end
  end

  def update_params
    params.require(:question).permit(:title, :content, :category_id)
  end
end
