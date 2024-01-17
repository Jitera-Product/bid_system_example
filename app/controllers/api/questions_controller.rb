class Api::QuestionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_contributor!

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
end
