class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]

  def create
    # Validate contributor role
    unless ContributorValidator.new(contributor_id: question_params[:contributor_id]).valid?
      render json: { error: 'User is not a contributor' }, status: :forbidden
      return
    end

    # Validate presence of title and content
    if question_params[:title].blank? || question_params[:content].blank?
      render json: { error: 'Title and content cannot be blank' }, status: :unprocessable_entity
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
      # Return the id of the newly created question to the contributor.
      render json: { id: result.question.id, title: result.question.title, content: result.question.content, tags: result.question.tags }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:contributor_id, :title, :content, tags: [])
  end
end
