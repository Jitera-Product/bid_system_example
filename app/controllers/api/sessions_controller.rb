
class Api::SessionsController < ApplicationController
  # Other actions...

  private
  
  # New logout action
  def logout
    user_id = params[:user_id]
    token = CustomAccessToken.find_by(user_id: user_id)
    if token
      token.revoke_for_user(user_id)
      render json: { message: 'Successfully logged out.' }, status: :ok
    else
      raise Exceptions::AuthenticationError, 'User not logged in or invalid token.'
    end
  rescue Exceptions::AuthenticationError => e
    render json: { error: e.message }, status: :unauthorized
  end
end
