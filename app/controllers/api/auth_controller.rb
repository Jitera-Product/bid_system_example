# PATH: /app/controllers/api/auth_controller.rb
class Api::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  # POST /api/auth/login
  def login
    username = params[:username]
    password = params[:password]

    # Validation for presence of username and password
    return render json: { error: 'Username and password are required' }, status: :bad_request unless username.present? && password.present?

    begin
      user = User.find_by(username: username)
      # Check if user exists
      return render json: { error: 'Username does not exist.' }, status: :unauthorized unless user

      # Authenticate user
      if user.authenticate(password)
        token = AuthenticationService.generate_token(user)
        render json: { status: 200, message: 'User authenticated successfully.', access_token: token }, status: :ok
      else
        render json: { error: 'Invalid password.' }, status: :unauthorized
      end
    rescue => e
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
  end

  # Other actions...
end
