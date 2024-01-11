class Api::AnswersController < Api::BaseController
  before_action :authenticate_user!

  def search
    query = params[:query]
    if query.present?
      search_service = AnswerSearchService.new
      results = search_service.perform_search(query)
      render json: { answers: results }, status: :ok
    else
      render json: { error: 'Query parameter is missing or empty.' }, status: :bad_request
    end
  rescue StandardError => e
    logger.error "Search failed: #{e.message}"
    render json: { error: 'An error occurred while searching for answers.' }, status: :internal_server_error
  end
end
