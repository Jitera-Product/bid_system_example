class Api::QuestionsController < Api::BaseController
  include SessionConcern
  before_action :doorkeeper_authorize!, only: [:show]

  def show
    query = params[:query]
    begin
      answer_content = AnswerService.retrieve_answer(query)
      if answer_content
        render json: { answer: answer_content }, status: :ok
      else
        render json: { error: I18n.t('questions.answers.not_found') }, status: :not_found
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def update
    validate_contributor_session(params[:contributor_id])
    question = Question.find(params[:question_id])
    policy = QuestionPolicy.new(current_user, question)

    if policy.update?
      service = QuestionService::Update.new
      if service.update(question_id: params[:question_id], contributor_id: params[:contributor_id], title: update_params[:title], content: update_params[:content], tags: update_params[:tags])
        render json: { message: 'Question updated successfully' }, status: :ok
      else
        render json: { errors: service.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this question' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Question not found' }, status: :not_found
  end

  private

  def update_params
    params.require(:question).permit(:title, :content, tags: [])
  end
end
