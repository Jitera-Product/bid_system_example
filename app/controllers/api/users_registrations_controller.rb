class Api::UsersRegistrationsController < Api::BaseController
  def create
    begin
      user_params = create_params
      UserValidator.new(user_params).validate
      user = UserService::CreateService.new(user_params).call
      UserService::SendConfirmationService.new(user).call
      render json: UserSerializer.new(user).serialized_json, status: :ok
    rescue Exceptions::ValidationError => e
      render json: { error_messages: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error_messages: e.message }, status: :internal_server_error
    end
  end
  private
  def create_params
    params.require(:user).permit(:name, :password, :confirmation_token)
  end
end
