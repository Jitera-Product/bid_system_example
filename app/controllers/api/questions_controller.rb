class Api::QuestionsController < Api::BaseController
  include SessionConcern
  include RoleConcern
  before_action :validate_contributor_session, only: [:update, :create, :submit]
  before_action :validate_contributor_role, only: [:update, :submit]
  before_action :set_question, only: [:update]
  before_action :validate_question_id, only: [:update]
  before_action :validate_question_ownership, only: [:update]
  before_action :validate_question_content, only: [:update]
  before_action :validate_tags, only: [:update]
  before_action :validate_categories, only: [:update]

  # ... other actions ...

  def create
    # Existing create action code remains unchanged
  end

  def update
    Question.transaction do
      # Existing tag validation and question content update code remains unchanged

      # Validate and update categories
      validate_categories(question_params[:categories])

      # Destroy existing categories before creating new ones
      @question.question_categories.destroy_all
      question_params[:categories].each do |category_id|
        @question.question_categories.create!(category_id: category_id)
      end

      # Existing response rendering code remains unchanged
      render json: {
        status: 200,
        question: {
          id: @question.id,
          content: @question.content,
          user_id: @question.user_id,
          updated_at: @question.updated_at.iso8601
        }
      }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'Question not found' }, status: :not_found
  end

  # Existing submit action code remains unchanged

  private

  def validate_contributor_session
    # Existing private methods remain unchanged
  end

  def validate_contributor_role
    # Existing private methods remain unchanged
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
      render json: { message: 'You can only edit your own questions.' }, status: :forbidden and return
    end
  end

  def validate_question_content
    if question_params[:content].blank?
      render json: { message: 'The content is required.' }, status: :unprocessable_entity and return
    end
  end

  def validate_tags
    tags = question_params[:tags]
    unless tags.is_a?(Array)
      render json: { message: 'Tags must be an array.' }, status: :unprocessable_entity and return
    end
    unless Tag.where(id: tags).count == tags.size
      render json: { message: 'One or more tags are invalid' }, status: :unprocessable_entity and return
    end
  end

  def validate_categories
    categories = question_params[:categories]
    unless categories.is_a?(Array)
      render json: { message: 'Categories must be an array.' }, status: :unprocessable_entity and return
    end
    unless Category.where(id: categories).count == categories.size
      render json: { message: 'One or more categories are invalid' }, status: :unprocessable_entity and return
    end
  end

  def question_params
    params.require(:question).permit(:content, :contributor_id, tags: [], categories: [])
  end
end
