class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update swipe]
  def index
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
    if @user.update(update_params)
      render json: { message: 'User profile updated successfully.' }, status: :ok
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  def update_params
    params.require(:user).permit(:age, :gender, :location, :interests, :preferences)
  end
  def swipe
    @user = User.find_by('users.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @user.blank?
    authorize @user, policy_class: Api::UsersPolicy
    match_id = params[:match_id]
    action = params[:action]
    if !%w[like pass].include?(action)
      render json: { error: 'Invalid action type.' }, status: :unprocessable_entity
      return
    end
    result = MatchService.update_match_status(@user.id, match_id, action)
    case result
    when 'Match not found'
      render json: { error: 'This match is not found' }, status: :not_found
    when 'Match status updated successfully'
      match = Match.find(match_id)
      render json: { status: 200, match: match }, status: :ok
    else
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
end
