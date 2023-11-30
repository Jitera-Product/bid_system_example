class Api::UsersRegistrationsController < Api::BaseController
  def register
    user_params = register_params
    result = UserService::Create.call(user_params)
    if result.success?
      render json: { status: 200, user: result.user }, status: :ok
    else
      render json: { error: result.error }, status: :bad_request
    end
  end
  private
  def register_params
    params.require(:user).permit(:name, :age, :gender, :location, :interests, :preferences)
  end
end
