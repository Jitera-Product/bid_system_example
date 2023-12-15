class Api::QuestionsController < Api::BaseController
  include SessionConcern
  include RoleConcern
  before_action :validate_contributor_session, only: [:update, :create]
  before_action :validate_contributor_role, only: [:update]
  before_action :set_question, only: [:update]

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
    validate_question_id(params[:id])
    validate_question_ownership(@question, contributor_id)
    validate_question_content(params[:content])
    validate_tags(params[:tags])

    Question.transaction do
      update_status = QuestionUpdatingService.new(
        question: @question,
        content: params[:content],
        tags: params[:tags]
      ).execute

      if update_status
        @question.question_tags.destroy_all
        params[:tags].each do |tag_id|
          @question.question_tags.create!(tag_id: tag_id)
        end
      end
    end

    render json: { update_status: update_status }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :unprocessable_entity
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
    raise ActiveRecord::RecordNotFound unless @question
  end

  def validate_question_id(question_id)
    QuestionValidator.validate_id(question_id)
  end

  def validate_question_ownership(question, contributor_id)
    raise ActiveRecord::RecordInvalid unless question.user_id == contributor_id
  end

  def validate_question_content(content)
    QuestionValidator.validate_content(content)
  end

  def validate_tags(tags)
    tags.each do |tag_id|
      TagValidator.validate_id(tag_id)
    end
  end

  def contributor_id
    # Assuming SessionConcern provides a method to get contributor_id from session
    session_contributor_id
  end

  def question_params
    params.require(:question).permit(:content, :contributor_id, tags: [])
  end
end
