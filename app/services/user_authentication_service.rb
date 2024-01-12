# typed: true
require 'exceptions'

class UserAuthenticationService < BaseService
  include Exceptions

  def authenticate_user(username:, password_hash:)
    user = User.find_by(username: username)
    raise AuthenticationError, 'User does not exist' if user.nil?

    unless user.valid_password?(password_hash)
      raise AuthenticationError, 'Invalid credentials'
    end

    session_token = Devise.friendly_token
    user.update_last_login_time
    user.save!

    { session_token: session_token, role: user.role }
  rescue ActiveRecord::RecordInvalid => e
    raise AuthenticationError, e.message
  end
end
