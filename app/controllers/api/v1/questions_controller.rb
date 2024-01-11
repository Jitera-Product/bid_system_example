class Api::V1::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :check_contributor_role, only: [:create]
  before_action :validate_question_params, only: [:create, :update]
  before_action :check_question_ownership, only: [:update]

  def create
    ActiveRecord::Base.transaction do
      question = Question.new(question_params)
      question.user = current_user
      if question.save
        process_tags(question, params[:tags])
        render json: { status: 201, question: question.as_json(include: [:category, :tags], methods: :user_id) }, status: :created
      else
        render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def update
    question = Question.find_by(id: params[:id])
    return render json: { error: 'This question is not found.' }, status: :not_found unless question

    ActiveRecord::Base.transaction do
      if question.update(question_params)
        process_tags(question, params[:tags]) if params[:tags].present?
        render json: { status: 200, question: question.as_json(include: [:category, :tags], methods: :user_id) }, status: :ok
      else
        render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  rescue_from StandardError do |exception|
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :category_id, tags: [])
  end

  def process_tags(question, tag_ids)
    return unless tag_ids.is_a?(Array)

    question.tags.clear
    tag_ids.uniq.each do |tag_id|
      tag = Tag.find_by(id: tag_id)
      question.tags << tag if tag
    end
  end

  def check_contributor_role
    unless current_user.contributor?
      render json: { error: 'User does not have permission to submit questions.' }, status: :forbidden
    end
  end

  def check_question_ownership
    question = Question.find_by(id: params[:id])
    unless question && (question.user_id == current_user.id || current_user.admin?)
      render json: { error: 'User does not have permission to edit this question.' }, status: :forbidden
    end
  end

  def validate_question_params
    errors = []
    errors << "The title is required." if params[:question][:title].blank?
    errors << "The content is required." if params[:question][:content].blank?
    errors << "The category is required." if params[:question][:category_id].blank?
    errors << "Tags must be an array of tag IDs." unless params[:tags].nil? || (params[:tags].is_a?(Array) && params[:tags].all? { |t| t.is_a?(Integer) })
    errors << "The question ID is required." if params[:action] == 'update' && params[:id].blank?
    errors << "Wrong format." if params[:action] == 'update' && params[:id].present? && !params[:id].match?(/\A\d+\z/)
    if errors.any?
      render json: { errors: errors }, status: :bad_request
    end
  end
end
