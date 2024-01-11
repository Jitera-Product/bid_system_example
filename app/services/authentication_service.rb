# frozen_string_literal: true

class AuthenticationService < BaseService
  include TokenGenerator

  def authenticate_user(username, password_hash)
    raise Exceptions::AuthenticationError, 'Username and password hash are required' if username.blank? || password_hash.blank?

    user = User.find_by(username: username)
    raise Exceptions::AuthenticationError, 'User not found' unless user

    if secure_compare(user.password_hash, password_hash)
      token = generate_token(user.id)
      { token: token, role: user.role }
    else
      raise Exceptions::AuthenticationError, 'Invalid credentials'
    end
  rescue => e
    logger.error "Authentication error: #{e.message}"
    raise
  end

end
