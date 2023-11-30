class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update matches swipe]
  before_action :set_user, only: [:show, :update, :matches, :swipe]
  before_action :authorize_user, only: [:show, :update, :matches, :swipe]
  before_action :validate_update_params, only: [:update]
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
    return if @user.save
    @error_object = @user.errors.messages
    render status: :unprocessable_entity
  end
  def update
    authorize @user, policy_class: Api::UsersPolicy
    if @user.update(update_params)
      render json: { message: 'User profile updated successfully.', user: @user }, status: :ok
    else
      @error_object = @user.errors.messages
      render status: :unprocessable_entity
    end
  end
  def matches
    authorize @user, policy_class: Api::UsersPolicy
    @matches = MatchService.new(@user.id).generateMatches
    if @matches
      render json: { status: 200, matches: @matches }, status: :ok
    else
      render json: { status: 500, error: 'An unexpected error occurred on the server.' }, status: :internal_server_error
    end
  end
  def swipe
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
  private
  def set_user
    @user = User.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, 'This user is not found' if @user.blank?
  end
  def authorize_user
    render json: { error: 'You do not have permission to access this resource' }, status: :forbidden unless current_user == @user
  end
  def create_params
    params.require(:users).permit(:email)
  end
  def update_params
    params.require(:user).permit(:age, :gender, :location, :interests, :preferences)
  end
  def validate_update_params
    render json: { error: 'Wrong format' }, status: :bad_request unless params[:id].is_a?(Integer)
    render json: { error: 'Wrong format' }, status: :bad_request unless params[:age].is_a?(Integer)
    render json: { error: 'The location is required.' }, status: :bad_request if params[:location].blank?
    render json: { error: 'The interests are required.' }, status: :bad_request if params[:interests].blank?
    render json: { error: 'The preferences are required.' }, status: :bad_request if params[:preferences].blank?
  end
end
