class Api::AnswersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create update search]
  before_action :authenticate_contributor!, only: %i[create update search]
  before_action :set_answer, only: %i[update]
  before_action :validate_content_presence, only: %i[create update]
  before_action :validate_question_id, only: %i[create]
  before_action :validate_query_presence, only: %i[search] # Added validation for query presence

  # Existing create and update actions...

  def search
    begin
      # Assuming AnswerSearchService is the correct service to use
      search_service = AnswerSearchService.new
      search_results = search_service.search_by_query(params[:query])

      if search_results[:error].present?
        render json: { error: search_results[:error] }, status: :internal_server_error
      else
        # Updated to match the requirement format
        render json: { status: 200, answers: format_answers(search_results[:answers]) }, status: :ok
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # Existing private methods...

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

  def validate_query_presence
    # Added method to validate query presence
    render json: { error: 'The query is required.' }, status: :unprocessable_entity if params[:query].blank?
  end

  def format_answers(answers)
    # Method to format the answers according to the requirement
    answers.map do |answer|
      {
        id: answer.id,
        content: answer.content,
        question_id: answer.question_id,
        feedback_score: answer.feedback_score,
        created_at: answer.created_at
      }
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
