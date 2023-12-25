class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update]
  before_action :authenticate_contributor!, only: %i[update]
  before_action :set_answer, only: %i[update]
  before_action :validate_content_presence, only: %i[update]

  def update
    # Assuming AnswerUpdatingService exists and is correctly implemented
    answer_updating_service = AnswerUpdatingService.new
    updated_answer = answer_updating_service.update_answer(
      @answer.id,
      @answer.question_id,
      answer_params[:content],
      Time.current,
      current_contributor
    )

    if updated_answer.persisted?
      render json: AnswerSerializer.new(updated_answer).serialized_json, status: :ok
    else
      render json: { errors: updated_answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_contributor!
    # Assuming there's a method in ApplicationController that checks user's permissions
    # You might need to implement this method based on your application's authentication logic
    authorize! :update, @answer
  end

  def set_answer
    @answer = Answer.find_by(id: params[:id])
    unless @answer && @answer.contributor == current_contributor
      render json: { error: 'Answer not found or permission denied.' }, status: :not_found
    end
  end

  def validate_content_presence
    if params[:answer][:content].blank?
      render json: { error: 'The content is required.' }, status: :unprocessable_entity
    end
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end
