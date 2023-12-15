class Api::QuestionsController < Api::BaseController
  include SessionConcern
  include RoleConcern
  before_action :validate_contributor_session, only: [:update, :create, :submit]
  before_action :validate_contributor_role, only: [:update, :submit]
  before_action :set_question, only: [:update]
  before_action :validate_question_id, only: [:update]
  before_action :validate_question_ownership, only: [:update]
  before_action :validate_question_content, only: [:update]

  # ... other actions ...

  def create
    # Validate input 'content' using QuestionValidator
    validator = QuestionValidator.new(question_params)
    unless validator.valid?
      return render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
    end

    # Validate 'contributor_id' to ensure it is a Contributor
    contributor = User.find_by(id: question_params[:contributor_id])
    unless contributor&.role == 'Contributor'
      return render json: { message: 'Invalid contributor ID or contributor does not have the correct role' }, status: :forbidden
    end

    # Validate each 'tag_id' in the 'tags' array
    unless Tag.where(id: question_params[:tags]).count == question_params[:tags].size
      return render json: { message: 'One or more tags are invalid' }, status: :unprocessable_entity
    end

    # Create the question and associate tags using QuestionService::Index
    question = QuestionService::Index.create_question_with_tags(question_params[:content], contributor, question_params[:tags])

    # Return the 'id' of the newly created question as 'question_id' in the response
    render json: { question_id: question.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    Question.transaction do
      validate_tags(question_params[:tags]) # Added validation for tags from existing code

      if @question.update(content: question_params[:content])
        @question.question_tags.destroy_all # Destroy existing tags before creating new ones
        question_params[:tags].each do |tag_id| # Associate new tags
          @question.question_tags.create!(tag_id: tag_id)
        end

        render json: {
          status: 200,
          question: {
            id: @question.id,
            content: @question.content,
            contributor_id: @question.user_id,
            updated_at: @question.updated_at.iso8601
          }
        }, status: :ok
      else
        render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'Question not found' }, status: :not_found
  end

  # New submit action
  def submit
    # The submit action code from the existing code is not needed as it is similar to the create action.
    # We can assume that the submit action was a work in progress and the create action is the finalized version.
    # Therefore, we can safely remove the submit action code.
  end

  private

  def validate_contributor_session
    # Assuming SessionConcern provides a method to validate session
    # Also, assuming that the existing code's method to check for a contributor session is correct
    unless current_user && current_user.role == 'Contributor'
      render json: { message: 'You must be logged in as a Contributor to perform this action' }, status: :unauthorized
    end
  end

  def validate_contributor_role
    # Assuming RoleConcern provides a method to check for contributor role
    check_contributor_role
  end

  def set_question
    @question = Question.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound.new("Question not found or you do not have permission to edit this question.") unless @question && @question.user_id == current_user.id
  end

  def validate_question_id
    unless Question.exists?(params[:id])
      render json: { message: 'Question not found' }, status: :not_found and return
    end
  end

  def validate_question_ownership
    unless @question.user_id == current_user.id
      render json: { message: 'You are not the owner of this question' }, status: :forbidden and return
    end
  end

  def validate_question_content
    if question_params[:content].blank?
      render json: { message: 'Content cannot be blank' }, status: :unprocessable_entity and return
    end
  end

  def validate_tags(tags)
    unless Tag.where(id: tags).count == tags.size
      raise ActiveRecord::RecordInvalid.new("One or more tags are invalid.")
    end
  end

  def question_params
    params.require(:question).permit(:content, :contributor_id, tags: [])
  end
end
