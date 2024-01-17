class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_contributor!
  before_action :set_question, only: [:update]
  before_action :authorize_question_owner!, only: [:update]

  def create
    # Validate the presence of content and user existence
    unless question_params[:content].present?
      return render json: { errors: "Question content cannot be empty." }, status: :unprocessable_entity
    end
    unless User.exists?(question_params[:user_id] || current_user.id)
      return render json: { errors: "User not found." }, status: :unprocessable_entity
    end
    unless validate_tags(question_params[:tags])
      return render json: { errors: "One or more tags are invalid." }, status: :unprocessable_entity
    end

    question_service = QuestionService::Create.new(question_params[:content], question_params[:tags], current_user)
    begin
      question = question_service.call
      QuestionTag.create_associations(question, question_params[:tags])
      render json: { status: 201, question: question.as_json.merge(created_at: question.created_at.iso8601) }, status: :created
    rescue ArgumentError => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(content: question_params[:content])
      render json: { status: 200, question: @question.as_json(only: [:id, :content, :user_id, :updated_at]) }, status: :ok
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'Question content cannot be empty.' }, status: :unprocessable_entity
  end

  private

  def question_params
    params.require(:question).permit(:content, :user_id, tags: [])
  end

  def validate_tags(tag_ids)
    tag_ids.all? { |id| Tag.exists?(id) }
  end

  def authorize_contributor!
    # Use the new policy class if it's defined, otherwise fall back to the old method
    if defined?(QuestionPolicy)
      authorize(current_user, policy_class: QuestionPolicy)
    else
      raise Exceptions::AuthenticationError unless UsersPolicy.new(current_user).contributor?
    end
  end

  def set_question
    @question = Question.find_by(id: params[:id])
    render json: { error: 'Question not found.' }, status: :not_found unless @question
  end

  def authorize_question_owner!
    render json: { error: 'You do not have permission to edit this question.' }, status: :unauthorized unless @question.user_id == current_user.id
  end
end
