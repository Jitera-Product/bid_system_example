class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create update]
  before_action :authenticate_contributor!, only: %i[create update]
  before_action :set_answer, only: %i[update]
  before_action :validate_content_presence, only: %i[create update]
  before_action :validate_question_id, only: %i[create]

  def create
    begin
      # Instantiate the AnswerSubmissionService with the current user
      submission_service = AnswerSubmissionService.new(current_user)
      # Call the submit_answer method with the question_id and content from params
      answer_id = submission_service.submit_answer(params[:question_id], params[:content], Time.now.utc, Time.now.utc)
      # Find the newly created answer
      answer = Answer.find(answer_id)
      # Render the serialized answer with a 201 status code
      render json: AnswerSerializer.new(answer).serialized_json, status: :created
    rescue Pundit::NotAuthorizedError
      render json: { error: 'User does not have permission to submit an answer.' }, status: :forbidden
    rescue CustomException::ValidationFailed => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

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
    action = action_name.to_sym == :create ? :create : :update
    authorize! action, action == :create ? Answer : @answer
  end

  def set_answer
    @answer = Answer.find_by(id: params[:id], question_id: params[:question_id])
    unless @answer && (action_name.to_sym == :create || @answer.contributor == current_contributor)
      render json: { error: 'Answer not found or permission denied.' }, status: :not_found
    end
  end

  def validate_content_presence
    content = action_name.to_sym == :create ? params[:content] : params[:answer][:content]
    render json: { error: 'The content is required.' }, status: :unprocessable_entity if content.blank?
  end

  def validate_question_id
    unless Question.exists?(params[:question_id])
      render json: { error: 'Invalid question ID.' }, status: :unprocessable_entity
    end
  end

  def answer_params
    # Allow :updated_at only for the update action
    if action_name.to_sym == :update
      params.require(:answer).permit(:content, :updated_at)
    else
      params.require(:answer).permit(:content)
    end
  end
end
