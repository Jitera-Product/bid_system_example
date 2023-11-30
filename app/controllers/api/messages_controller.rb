class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  before_action :validate_params, only: %i[create]
  def create
    user = User.find_by(id: params[:id])
    return render json: { error: 'This user is not found' }, status: :not_found if user.nil?
    match = Match.find_by(id: params[:match_id])
    return render json: { error: 'This match is not found' }, status: :not_found if match.nil?
    message = Message.new(content: params[:content], user_id: user.id, match_id: match.id)
    if message.save
      render json: { status: 200, message: message }, status: :ok
    else
      render json: { error: 'Failed to send message', details: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def validate_params
    return render json: { error: 'Wrong format' }, status: :bad_request unless params[:id].present? && params[:id].is_a?(Integer)
    return render json: { error: 'Wrong format' }, status: :bad_request unless params[:match_id].present? && params[:match_id].is_a?(Integer)
    return render json: { error: 'The content is required.' }, status: :unprocessable_entity if params[:content].blank?
  end
end
