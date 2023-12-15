class Api::QuestionsController < Api::BaseController
  include SessionConcern
  include RoleConcern
  before_action :validate_contributor_session, only: [:update, :create, :submit]
  before_action :validate_contributor_role, only: [:update, :submit]
  before_action :set_question, only: [:update]

  # ... other actions ...

  def create
    # Existing create action code...
  end

  def update
    # Existing update action code...
  end

  # New submit action
  def submit
    # Validate input 'content' using QuestionValidator
    validator = QuestionValidator.new(question_params)
    unless validator.valid?
      return render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
    end

    # Validate 'contributor_id' to ensure it is a Contributor
    contributor = User.find_by(id: question_params[:contributor_id])
    unless contributor&.role == 'Contributor'
      return render json: { message: 'Invalid contributor ID or contributor not found.' }, status: :unprocessable_entity
    end

    # Validate each 'tag_id' in the 'tags' array
    unless Tag.where(id: question_params[:tags]).count == question_params[:tags].size
      return render json: { message: 'One or more tags are invalid.' }, status: :unprocessable_entity
    end

    # Create the question and associate tags
    question = Question.new(content: question_params[:content], user_id: question_params[:contributor_id])
    question.transaction do
      question.save!
      question_params[:tags].each do |tag_id|
        question.tags << Tag.find(tag_id)
      end
    end

    # Render the successful response
    render json: {
      status: 201,
      question: {
        id: question.id,
        content: question.content,
        contributor_id: question.user_id,
        created_at: question.created_at
      }
    }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  # Existing private methods...

  def question_params
    params.require(:question).permit(:content, :contributor_id, tags: [])
  end
end
