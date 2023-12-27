class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :set_user, only: %i[show update]
  before_action :validate_username_uniqueness, only: %i[update]

  def index
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    authorize @user, policy_class: Api::UsersPolicy
  end

  def create
    @user = User.new(create_params)

    authorize @user, policy_class: Api::UsersPolicy

    if @user.save
      render json: @user, status: :created
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end

  def create_params
    params.require(:users).permit(:email)
  end

  def update
    authorize @user, policy_class: Api::UsersPolicy

    if update_params[:password_hash].present?
      validate_password_strength(update_params[:password_hash])
      update_params[:password_hash] = @user.password_digest(update_params[:password_hash])
    end

    if @user.update(update_params.merge(updated_at: Time.current))
      AuditLogJob.perform_later('User Profile Updated', @user.id)
      render json: @user, status: :ok
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end

  def update_params
    params.require(:users).permit(:email, :username, :password_hash, :role)
  end

  private

  def set_user
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
  end

  def validate_username_uniqueness
    if update_params[:username].present? && @user.username != update_params[:username] && User.exists?(username: update_params[:username])
      render json: { error: 'Username already taken' }, status: :unprocessable_entity
      return
    end
  end

  def validate_password_strength(password)
    unless password =~ User::PASSWORD_FORMAT
      render json: { error: 'Password does not meet requirements' }, status: :unprocessable_entity
      return
    end
  end
end
