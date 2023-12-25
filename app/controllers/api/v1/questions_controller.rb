class Api::V1::QuestionsController < Api::BaseController
  include Authenticable
  before_action :doorkeeper_authorize!, only: %i[create update]
  before_action :authenticate_user!, except: %i[update]
  before_action :set_question, only: %i[update]
  before_action :validate_question_owner, only: %i[update]

  def create
    return unless validate_contributor_role

    question_params = params.require(:question).permit(:title, :content, :category_id)
    question_params[:contributor_id] = current_user.id

    validator = QuestionValidator.new(question_params)
    unless validator.valid?
      render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
      return
    end

    unless Category.exists?(question_params[:category_id])
      render json: { error: 'Invalid category ID.' }, status: :not_found
      return
    end

    question = Question.new(question_params)

    if question.save
      QuestionCategory.create(question_id: question.id, category_id: question_params[:category_id])
      render json: { status: 201, question: question.as_json.merge(created_at: question.created_at) }, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    validate_update_params

    if @question.update(update_params.merge(updated_at: Time.current))
      render json: { status: 200, question: QuestionSerializer.new(@question).serializable_hash }, status: :ok
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Exceptions::AuthenticationError => e
    render json: { errors: [e.message] }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Question not found or permission denied.'] }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: [e.message] }, status: :forbidden
  end

  # ... other actions in the controller ...

  private

  def validate_contributor_role
    unless current_user.role == 'Contributor'
      render json: { error: 'Invalid contributor ID or insufficient permissions.' }, status: :forbidden
      return false
    end
    true
  end

  def validate_update_params
    required_params = %i[title content category_id]
    required_params.each do |param|
      if update_params[param].blank?
        error_message = case param
                        when :title
                          'The title is required.'
                        when :content
                          'The content is required.'
                        when :category_id
                          'Invalid category ID.'
                        end
        raise StandardError, error_message
      end
    end

    unless Category.exists?(update_params[:category_id])
      raise StandardError, 'Invalid category ID.'
    end

    if update_params[:title].length > 200
      raise StandardError, 'The title cannot exceed 200 characters.'
    end
  end

  def set_question
    @question = Question.find_by!(id: params[:id])
  end

  def validate_question_owner
    unless @question.user_id == current_resource_owner.id
      raise StandardError, 'You are not authorized to update this question.'
    end
  end

  def update_params
    params.require(:question).permit(:title, :content, :category_id)
  end
end
