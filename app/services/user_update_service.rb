# rubocop:disable Style/ClassAndModuleChildren
class UserUpdateService
  include Pundit::Authorization

  def initialize(user_id, username, password_hash, current_user)
    @user_id = user_id
    @username = username
    @password_hash = password_hash
    @current_user = current_user
  end

  def call
    user = User.find(@user_id)
    authorize user, :update?

    if @current_user.admin? || @current_user == user
      if User.exists?(username: @username)
        return { error: 'Username already taken' }
      end

      if @password_hash.present?
        # Assuming Devise is used for user management
        user.password = @password_hash
        user.save!
      end

      user.update!(username: @username)
      { user_id: user.id, message: 'User profile updated successfully' }
    else
      { error: 'Not authorized to update user profile' }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
