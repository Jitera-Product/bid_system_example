class Api::AnswersController < Api::BaseController
  include OauthTokensConcern
  before_action :set_answer, only: [:update]
  before_action :authenticate_user, :check_contributor_role, only: [:update]
  before_action :authenticate_user!, except: [:update]

  # PATCH/PUT /api/answers/:id
  def update
    begin
      @answer.update!(answer_params)
      render json: { answer_id: @answer.id }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Update failed: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError => e
      logger.error "Authorization failed: #{e.message}"
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    end
  end

  # GET /api/answers/search
  def search
    query = params[:query]
    if query.blank?
      render json: { error: 'The query is required.' }, status: :bad_request
    else
      begin
        search_service = AnswerSearchService.new
        results = search_service.perform_search(query)
        answers = results.map do |answer|
          {
            id: answer.id,
            content: answer.content,
            question_id: answer.question_id,
            created_at: answer.created_at
          }
        end
        render json: { status: 200, answers: answers }, status: :ok
      rescue StandardError => e
        logger.error "Search failed: #{e.message}"
        render json: { error: 'An error occurred while searching for answers.' }, status: :internal_server_error
      end
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
    authorize @answer, :update?
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Answer not found." }, status: :not_found
  end

  def answer_params
    params.require(:answer).permit(:content)
  end

  def authenticate_user
    # Method to authenticate user permissions
  end

  def check_contributor_role
    render json: { error: "You must have Contributor role to perform this action." }, status: :forbidden unless current_user.role == 'Contributor'
  end
end
