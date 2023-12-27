class Api::QuestionsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :require_contributor_role, only: [:create]

  def create
    ActiveRecord::Base.transaction do
      @question = Question.new(question_params)
      validate_input_presence!
      validate_user!
      validate_categories(question_params[:category_ids])
      @question.save!
      create_question_category_mappings(@question, question_params[:category_ids])
      render json: { question_id: @question.id }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, :user_id, category_ids: [])
  end

  def require_contributor_role
    unless current_resource_owner.has_role?(:contributor)
      render json: { error: 'You must have the contributor role to perform this action.' }, status: :forbidden
    end
  end

  def validate_input_presence!
    if question_params[:title].blank? || question_params[:content].blank?
      raise ActiveRecord::RecordInvalid.new(@question), 'Title and content cannot be empty.'
    end
  end

  def validate_user!
    unless User.exists?(question_params[:user_id])
      raise ActiveRecord::RecordNotFound, 'User not found.'
    end
  end

  def validate_categories(category_ids)
    if Category.where(id: category_ids).count != category_ids.size
      raise ActiveRecord::RecordNotFound, 'One or more categories not found.'
    end
  end

  def create_question_category_mappings(question, category_ids)
    category_ids.each do |category_id|
      QuestionCategoryMapping.create!(question_id: question.id, category_id: category_id)
    end
  end
end
