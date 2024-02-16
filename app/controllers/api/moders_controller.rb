# typed: ignore
module Api
  class ModersController < BaseController
    def signup
      email = params[:email]
      password = params[:password]
      service = ModersEmailAuthService.new
      result = service.signup(email, password)

      if result[:success]
        render json: { user: result[:user] }, status: :ok
      else
        render json: { message: result[:error] }, status: :bad_request
      end
    end

    private
  end
end
