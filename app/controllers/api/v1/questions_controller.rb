class Api::V1::QuestionsController < Api::BaseController
  include Authenticable
  before_action :doorkeeper_authorize!, only: %i[create update]
  before_action :authenticate_user!, except: %i[update]
  before_action :set_question, only: %i[update]
  before_action :validate_question_owner, only: %i[update]
  before_action :validate_contributor_role, only: %i[create]

  def create
    question_params = params.require(:question).permit(:title, :content, category_ids: [])
    question_params[:user_id] = current_user.id

    if question_params[:title].blank? || question_params[:content].blank?
      render json: { error: 'Title and content are required.' }, status: :unprocessable_entity
      return
    end

    unless User.exists?(question_params[:user_id])
      render json: { error: 'User not found.' }, status: :not_found
      return
    end

    invalid_category_ids = question_params[:category_ids].reject { |id| Category.exists?(id) }
    if invalid_category_ids.any?
      render json: { error: 'One or more categories not found.', invalid_category_ids: invalid_category_ids }, status: :not_found
      return
    end

    question = Question.new(title: question_params[:title], content: question_params[:content], user_id: question_params[:user_id])

    ActiveRecord::Base.transaction do
      if question.save
        question_params[:category_ids].each do |category_id|
          QuestionCategoryMapping.create!(question_id: question.id, category_id: category_id)
        end
        render json: { id: question.id }, status: :created
      else
        render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
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
