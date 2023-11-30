class Api::UsersRegistrationsController < Api::BaseController
  def create
    user_params = create_params
    result = UserService.create(user_params)
    if result[:success]
      render json: { user_id: result[:user].id }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end
  private
  def create_params
    params.require(:user).permit(:name, :age, :gender, :location, :interests, :preferences)
  end
end
