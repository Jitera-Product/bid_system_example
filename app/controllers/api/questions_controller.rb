class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_contributor!, except: [:update]
  before_action :set_question, only: [:update]
  before_action :authorize_question_owner!, only: [:update]

  def create
    question = Question.new(content: question_params[:content], user_id: current_user.id)
    if question.valid? && validate_tags(question_params[:tags])
      question.save!
      QuestionTag.create_associations(question, question_params[:tags])
      render json: { question_id: question.id }, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
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
    params.require(:question).permit(:content, tags: [])
  end

  def validate_tags(tag_ids)
    tag_ids.all? { |id| Tag.exists?(id) }
  end

  def authorize_contributor!
    raise Exceptions::AuthenticationError unless UsersPolicy.new(current_user).contributor?
  end

  def set_question
    @question = Question.find_by(id: params[:id])
    render json: { error: 'Question not found.' }, status: :not_found unless @question
  end

  def authorize_question_owner!
    render json: { error: 'You do not have permission to edit this question.' }, status: :unauthorized unless @question.user_id == current_user.id
  end
end
