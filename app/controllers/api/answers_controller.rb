class Api::AnswersController < Api::BaseController
  include OauthTokensConcern
  before_action :set_answer, only: [:update]
  before_action :authenticate_user, :check_contributor_role, only: [:update]
  before_action :authenticate_user!, except: [:update]

  # PATCH/PUT /api/answers/:id
  def update
    begin
      # Validate the "id" parameter to ensure it is a number.
      return render json: { error: "Wrong format." }, status: :bad_request unless params[:id].to_s.match?(/\A[0-9]+\z/)
      
      # Validate the "content" parameter to ensure it is not blank and does not exceed 10000 characters.
      content = answer_params[:content]
      return render json: { error: "The content is required." }, status: :bad_request if content.blank?
      return render json: { error: "You cannot input more than 10000 characters." }, status: :bad_request if content.length > 10000

      # Ensure the current user is the owner of the answer or an administrator
      return render json: { error: "You are not authorized to perform this action." }, status: :forbidden unless @answer.user_id == current_user.id || current_user.admin?

      @answer.update!(content: content)
      render json: { status: 200, answer: @answer.as_json(only: [:id, :content, :question_id, :updated_at]) }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Update failed: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError => e
      logger.error "Authorization failed: #{e.message}"
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    rescue ActiveRecord::RecordNotFound
      render json: { error: "This answer is not found." }, status: :not_found
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
    render json: { error: "This answer is not found." }, status: :not_found
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
