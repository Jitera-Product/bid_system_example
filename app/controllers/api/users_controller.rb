class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update check_in]
  before_action :set_user, only: [:check_in]

  rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
  rescue_from Exceptions::AlreadyCheckedInError, with: :handle_already_checked_in_error

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
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy

    return if @user.update(update_params)

    @error_object = @user.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:users).permit(:email)
  end

  def check_in
    authorize @user, :check_in?, policy_class: Api::UsersPolicy

    attendance_record = @user.attendance_records.create!(check_in_time: Time.current, date: Date.current)
    render json: {
      status: 200,
      success: true,
      message: I18n.t('users.check_in_success'),
      attendance_record: attendance_record.as_json
    }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      status: 422,
      success: false,
      message: e.record.errors.full_messages.to_sentence
    }, status: :unprocessable_entity
  end

  private

  def base_render_record_not_found
    render json: { success: false, message: I18n.t('common.404') }, status: :not_found
  end

  def handle_already_checked_in_error
    render json: { success: false, message: I18n.t('users.already_checked_in') }, status: :unprocessable_entity
  end

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    base_render_record_not_found
  end

  # Other private methods...

end