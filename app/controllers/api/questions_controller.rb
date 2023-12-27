class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]

  def create
    # Validate contributor role
    unless ContributorValidator.new(contributor_id: question_params[:contributor_id]).valid?
      render json: { error: 'Invalid contributor ID or insufficient permissions.' }, status: :forbidden
      return
    end

    # Validate presence of title and content
    if question_params[:title].blank?
      render json: { error: 'The title is required.' }, status: :unprocessable_entity
      return
    elsif question_params[:title].length > 200
      render json: { error: 'The title cannot exceed 200 characters.' }, status: :unprocessable_entity
      return
    end

    if question_params[:content].blank?
      render json: { error: 'The content is required.' }, status: :unprocessable_entity
      return
    end

    # Validate tags
    unless TagValidator.new(tag_ids: question_params[:tags]).valid?
      render json: { error: 'One or more tags are invalid.' }, status: :unprocessable_entity
      return
    end

    # Create question and associated tags using the service
    result = QuestionSubmissionService.new(
      question_params[:contributor_id],
      question_params[:title],
      question_params[:content],
      question_params[:tags]
    ).call

    if result[:success]
      render json: { status: 201, question: result.except(:success) }, status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def question_params
    params.require(:question).permit(:contributor_id, :title, :content, tags: [])
  end
end
