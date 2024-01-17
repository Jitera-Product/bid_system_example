
class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :authenticate_contributor!, only: [:submit_answer]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy
  end

  def create
    @user = User.new(create_params)

    authorize @user, policy_class: Api::UsersPolicy

    return if @user.save

    @error_object = @user.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:users).permit(:email)
  end

  def update
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?

    authorize @user, policy_class: Api::UsersPolicy

    return if @user.update(update_params)

    @error_object = @user.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:users).permit(:email)
  end

  def submit_answer
    unless validate_answer_submission(params[:content], params[:question_id])
      return
    end

    answer = Answer.new(content: params[:content], question_id: params[:question_id], user_id: current_user.id)

    if answer.save
      render json: { answer_id: answer.id }, status: :created
    else
      render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def validate_answer_submission(content, question_id)
    content.present? && Question.exists?(question_id)
  end
end
