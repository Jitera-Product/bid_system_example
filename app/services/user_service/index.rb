
# rubocop:disable Style/ClassAndModuleChildren
require 'securerandom'
class UserService::Index
  include Pundit::Authorization

  attr_accessor :params, :records, :query

  def initialize(params, current_user = nil)
    @params = params

    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
  end

  def execute
    email_start_with

    order

    paginate
  end

  def email_start_with
    return if params.dig(:users, :email).blank?

    @records = User.where('email like ?', "%#{params.dig(:users, :email)}")
  end

  def order
    return if records.blank?

    @records = records.order('users.created_at desc')
  end

  def paginate
    @records = User.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end

  def authenticate_user(username, password_hash)
    raise Exceptions::AuthenticationError, "Username and password hash are required" if username.blank? || password_hash.blank?

    user = User.find_for_authentication(email: username)
    raise Exceptions::AuthenticationError, "Invalid username or password" unless user

    unless user.valid_password?(password_hash)
      user.log_login_attempt(false)
      raise Exceptions::AuthenticationError, "Invalid username or password"
    end

    user.log_login_attempt(true)
    session_token = user.generate_session_token

    { session_token: session_token, role: user.role }
  rescue Exceptions::AuthenticationError => e
    { error: e.message }
  end
end

# Additional methods in User model
class User < ApplicationRecord
  def generate_session_token
    SecureRandom.hex(10)
  end

  def log_login_attempt(success)
    # Log login attempt here
  end
end
# rubocop:enable Style/ClassAndModuleChildren
