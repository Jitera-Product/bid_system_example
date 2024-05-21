class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found

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
    user = User.find(params[:user_id])
    if AttendanceRecord.where(user_id: user.id, date: Date.current, check_out_time: nil).exists?
      render json: { success: false, message: I18n.t('users.already_checked_in') }, status: :unprocessable_entity
    else
      attendance_record = user.attendance_records.create!(check_in_time: Time.current, date: Date.current)
      render json: { success: true, message: I18n.t('users.check_in_success'), attendance_record: attendance_record }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    base_render_record_not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, message: e.record.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def base_render_record_not_found
    render json: { success: false, message: I18n.t('common.404') }, status: :not_found
  end

  # Other private methods...

end