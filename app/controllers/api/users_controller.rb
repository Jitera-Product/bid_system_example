class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update submit_kyc_info restrict]
  def restrict
    user_id = params[:id]
    unless user_id.is_a?(Integer)
      return render json: { error: 'Wrong format' }, status: :bad_request
    end
    begin
      result = UserService::Restrict.new(user_id).execute
      if result.success?
        render json: { status: 200, message: "User's features have been restricted due to KYC process timeout." }, status: :ok
      else
        render json: { error: 'Internal Server Error' }, status: :internal_server_error
      end
    rescue => e
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end
end
