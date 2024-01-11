class Api::V1::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :check_contributor_role, only: [:create]
  before_action :validate_question_params, only: [:create]
  before_action :validate_question_params, only: [:update]

  def create
    question = Question.new(question_params)
    question.user = current_user
    if question.save
      process_tags(question, params[:tags])
      render json: { status: 201, question: question.as_json(include: [:category, :tags], methods: :user_id) }, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    question = Question.find_by(id: params[:id])
    return render json: { error: 'Question not found.' }, status: :not_found unless question
    return render json: { error: 'User does not have permission to edit this question.' }, status: :forbidden unless question.user_id == current_user.id

    if question.update(question_params)
      process_tags(question, params[:tags]) if params[:tags].present?
      render json: { status: 200, message: 'Question updated successfully.', question: question.as_json(include: [:category, :tags], methods: :user_id) }, status: :ok
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def validate_question_params
    super
    errors << "The question ID is required." if params[:action] == 'update' && params[:id].blank?
    render json: { errors: errors }, status: :bad_request if errors.any?
  end

  def question_params
    params.require(:question).permit(:title, :content, :category_id)
  end

  def process_tags(question, tags)
    return unless tags.is_a?(Array)

    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      QuestionTag.create(question: question, tag: tag)
    end
  end

  def check_contributor_role
    unless current_user.contributor?
      render json: { error: 'User does not have permission to submit questions.' }, status: :forbidden
    end
  end

  def validate_question_params
    errors = []
    errors << "The title is required." if params[:question][:title].blank?
    errors << "The content is required." if params[:question][:content].blank?
    errors << "The category is required." if params[:question][:category_id].blank?
    errors << "Tags must be an array." unless params[:tags].is_a?(Array)
    if errors.any?
      render json: { errors: errors }, status: :bad_request
    end
  end
end
