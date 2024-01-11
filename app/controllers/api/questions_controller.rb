class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!

  def create
    question_service = QuestionSubmissionService.new(question_params, current_user)
    if question_service.submit
      render json: { question_id: question_service.question.id }, status: :created
    else
      render json: { errors: question_service.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :category, tags: [])
  end
end
