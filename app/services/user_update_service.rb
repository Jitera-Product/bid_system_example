
# rubocop:disable Style/ClassAndModuleChildren
class UserUpdateService
  include Pundit::Authorization
  attr_reader :user_id, :username, :password_hash, :current_user, :role, :admin_id

  def initialize(user_id, username, password_hash, current_user, role = nil, admin_id = nil)
    @user_id = user_id
    @username = username
    @password_hash = password_hash
    @current_user = current_user
    @role = role
    @admin_id = admin_id
  end

  def call
    user = User.find(@user_id)
    authorize user, :update?

    validate_role_change if role.present?
    if @current_user.admin? || @current_user == user
      if User.exists?(username: @username)
        return { error: 'Username already taken' }
      end

      if @password_hash.present?
        if validate_password_hash
          user.password = @password_hash
        else
          return { error: 'Invalid password format' }
        end
        user.save!
      end

      update_status = user.update(username: @username, role: role)
      if update_status
        { user_id: user.id, message: 'User profile updated successfully', update_status: update_status }
      else
        { error: 'User profile update failed' }
      end
    else
      { error: 'Not authorized to update user profile' }
    end
  end

  private

  def validate_role_change
    admin_user = User.find(@admin_id)
    unless admin_user&.admin?
      raise Pundit::NotAuthorizedError, 'You must be an admin to change user roles.'
    end
  end

  def validate_password_hash
    # Placeholder for password validation logic
    # This should be replaced with actual validation logic
    @password_hash.length >= 8
  end
end
# rubocop:enable Style/ClassAndModuleChildren
