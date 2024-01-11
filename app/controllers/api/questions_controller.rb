class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :check_contributor_role, only: [:create]

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

  private

  def question_params
    params.require(:question).permit(:title, :content, :category, tags: [])
  end

  def check_contributor_role
    unless current_user.has_role?(:contributor)
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
end
