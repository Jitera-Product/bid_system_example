class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!, only: [:create]
  before_action :check_contributor_role, only: [:create]

  def create
    validate_question_params
    question_service = QuestionSubmissionService.new(question_params, current_user)
    if question_service.submit
      question = question_service.question
      render json: { question_id: question.id }, status: :created
    else
      render json: { errors: question_service.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params # Sanitize input parameters to prevent SQL injection
    params.require(:question).permit(:title, :content, :category, tags: [])
  end

  def check_contributor_role
    unless current_user.has_role?(:contributor)
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end # End of check_contributor_role method

  def validate_question_params
    errors = {}
    errors[:title] = "The title is required." if params[:question][:title].blank?
    errors[:content] = "The content is required." if params[:question][:content].blank?
    errors[:category] = "The category is required." if params[:question][:category].blank?
    errors[:tags] = "Tags must be an array." unless params[:question][:tags].is_a?(Array)
    render json: { errors: errors }, status: :unprocessable_entity if errors.any? # Render error response if validation fails
  end
end
