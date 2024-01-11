class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :check_contributor_role, only: [:create, :update]
  before_action :check_question_ownership, only: [:update]

  def create
    validate_question_params
    question_service = QuestionSubmissionService.new(question_params, current_user)
    if question_service.submit
      question = question_service.question
      render json: { status: 201, question: question.as_json.merge(contributor_id: current_user.id, created_at: question.created_at) }, status: :created
    else
      render json: { errors: question_service.errors }, status: :unprocessable_entity
    end
  end

  def update
    question = Question.find_by(id: params[:id])
    return render json: { error: 'Question not found' }, status: :not_found unless question

    if question.update(question_params)
      # Update tags if provided
      update_tags(question) if params[:question][:tags].present?
      render json: { status: 200, question_id: question.id }, status: :ok
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :category, tags: [])
  end

  def check_contributor_role
    unless current_user.has_role?(:contributor)
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def check_question_ownership
    question = Question.find_by(id: params[:id])
    unless question&.user_id == current_user.id
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def validate_question_params
    errors = {}
    errors[:title] = "The title is required." if params[:question][:title].blank?
    errors[:content] = "The content is required." if params[:question][:content].blank?
    errors[:category] = "The category is required." if params[:question][:category].blank?
    errors[:tags] = "Tags must be an array." unless params[:question][:tags].is_a?(Array)
    render json: { errors: errors }, status: :unprocessable_entity if errors.any?
  end

  def update_tags(question)
    # Logic to update tags
  end
end
