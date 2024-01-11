class Api::V1::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :check_contributor_role, only: [:create]
  before_action :validate_question_params, only: [:create]

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

  private

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
