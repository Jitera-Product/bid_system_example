# /app/services/user_update_service.rb

class UserUpdateService
  include Devise::Models # Assuming Devise is included in the project

  def update_user_profile(user_id, username, password_hash, role, updated_at)
    ActiveRecord::Base.transaction do
      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordNotFound, "User not found" unless user

      if username != user.username && User.exists?(username: username)
        raise ActiveRecord::RecordInvalid, "Username already taken"
      end

      if password_hash.present?
        raise ActiveRecord::RecordInvalid, "Password does not meet complexity requirements" unless password_complexity(password_hash)
        password_hash = User.encrypt_password(password_hash)
      end

      user.update!(
        username: username,
        encrypted_password: password_hash || user.encrypted_password,
        role: role,
        updated_at: updated_at
      )

      AuditLogJob.perform_later(user_id: user.id, action: 'profile_update')

      { success: true, user: user }
    end
  rescue ActiveRecord::RecordNotFound => e
    { success: false, error: e.message }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end

  private

  def password_complexity(password)
    password.length >= 8 && password.match?(/\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])\z/)
  end
end
