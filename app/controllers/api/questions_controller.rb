class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create, :update] # Added :update to the before_action for doorkeeper_authorize!
  before_action :check_administrator_role, only: [:update] # Added a new before_action for checking administrator role

  def create
    # Validate contributor role
    unless ContributorValidator.new(contributor_id: question_params[:contributor_id]).valid?
      render json: { error: 'User is not a contributor' }, status: :forbidden
      return
    end

    # Validate presence of title and content
    if question_params[:title].blank?
      render json: { error: 'Title and content cannot be blank' }, status: :unprocessable_entity
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
      render json: { error: 'One or more tags are invalid' }, status: :unprocessable_entity
      return
    end

    # Create question and associated tags using the service
    result = QuestionSubmissionService.new(question_params).execute

    if result.success?
      render json: { status: 201, question: { id: result.question.id, title: result.question.title, content: result.question.content, tags: result.question.tags } }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    question = Question.find_by(id: params[:id])
    return render json: { error: 'Question not found.' }, status: :not_found unless question

    if params[:title] && params[:title].length > 200
      return render json: { error: 'The title cannot exceed 200 characters.' }, status: :unprocessable_entity
    end

    if params[:tags] && !Tag.where(id: params[:tags]).all? { |tag| Tag.exists?(tag.id) }
      return render json: { error: 'One or more tags are invalid.' }, status: :unprocessable_entity
    end

    begin
      # Update the question with the provided parameters
      question.update!(params.permit(:title, :content, :tags))
      # Return the updated question
      render json: {
        status: 200,
        question: {
          id: question.id,
          title: question.title,
          content: question.content,
          contributor_id: question.contributor_id,
          updated_at: question.updated_at
        }
      }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:contributor_id, :title, :content, tags: [])
  end

  def check_administrator_role
    render json: { error: 'User is not an administrator' }, status: :forbidden unless current_user.role == 'Administrator'
  end
end
