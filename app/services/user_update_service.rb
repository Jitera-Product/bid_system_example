# rubocop:disable Style/ClassAndModuleChildren
class UserUpdateService
  include Pundit::Authorization

  def update_user_profile(user_id, username, password_hash, role = nil, admin_id = nil)
    user = User.find(user_id)
    UserService.authenticate_user(user_id)

    if User.exists?(username: username) && user.username != username
      raise StandardError.new('Username is already taken')
    end

    # Assuming there is a method to validate password hash complexity
    unless valid_password_hash?(password_hash)
      raise StandardError.new('Password hash does not meet security requirements')
    end

    user.update!(username: username, password_digest: password_hash)

    if role.present? && user.role != role
      admin = User.find(admin_id)
      raise Pundit::NotAuthorizedError unless UserPolicy.new(admin, user).update_role?

      user.update!(role: role)
    end

    { update_status: 'Profile updated successfully' }
  rescue ActiveRecord::RecordNotFound => e
    { error: e.message }
  rescue Pundit::NotAuthorizedError => e
    { error: e.message }
  rescue StandardError => e
    { error: e.message }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
