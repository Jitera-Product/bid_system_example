class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :check_contributor_role, only: [:create, :update]
  before_action :check_question_ownership, only: [:update]

  def create
    validate_question_params
    question_service = QuestionSubmissionService.new(question_params, current_user)
    if question_service.submit
      question = question_service.question
      render json: { status: 201, question: question.as_json.merge(contributor_id: current_user.id, created_at: question.created_at) }, status: :created
    else
      render json: { errors: question_service.errors }, status: :unprocessable_entity
    end
  end

  def update
    return render json: { error: "Wrong format." }, status: :bad_request unless params[:id].to_s.match?(/\A\d+\z/)
    question = Question.find_by(id: params[:id])
    return render json: { error: "This question is not found." }, status: :not_found unless question

    validate_question_params
    return if performed?

    if question.update(question_update_params)
      update_tags(question) if params[:question][:tags].present?
      render json: { status: 200, question: question.as_json.merge(updated_at: question.updated_at, user_id: question.user_id) }, status: :ok
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :category, tags: [])
  end

  def question_update_params
    params.require(:question).permit(:title, :content, :category, tags: [])
  end

  def check_contributor_role
    unless current_user.has_role?(:contributor)
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def check_question_ownership
    question = Question.find_by(id: params[:id])
    unless question&.user_id == current_user.id
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def validate_question_params
    errors = {}
    errors[:title] = "The title is required." if params[:question][:title].blank?
    errors[:title] = "You cannot input more than 200 characters." if params[:question][:title].to_s.length > 200
    errors[:content] = "The content is required." if params[:question][:content].blank?
    errors[:category] = "The category is required." if params[:question][:category].blank?
    errors[:tags] = "Tags must be an array." unless params[:question][:tags].is_a?(Array)
    render json: { errors: errors }, status: :unprocessable_entity if errors.any?
  end

  def update_tags(question)
    existing_tags = question.tags.pluck(:name)
    new_tags = params[:question][:tags].reject(&:blank?)
    removed_tags = existing_tags - new_tags
    added_tags = new_tags - existing_tags

    # Remove the tags that are no longer associated with the question
    removed_tags.each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      question.tags.delete(tag) if tag
    end

    # Add new tags to the question
    added_tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      question.tags << tag unless question.tags.include?(tag)
    end
  end
end
