class UpdatePasswordService
  def initialize(user_id, new_password)
    @user_id = user_id
    @new_password = new_password
  end
  def call
    user = User.find_by(id: @user_id)
    return { status: 'error', message: 'User not found' } unless user
    if valid_password?(@new_password)
      encrypted_password = Devise::Encryptor.digest(User, @new_password)
      begin
        user.update!(encrypted_password: encrypted_password)
        create_password_update_record
        send_password_update_confirmation
        { status: 'success', message: 'Password updated successfully', user_id: user.id, name: user.name }
      rescue StandardError => e
        { status: 'error', message: e.message }
      end
    else
      { status: 'error', message: 'Invalid password format' }
    end
  end
  private
  def valid_password?(password)
    # Add your password validation logic here
    # For example, the password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, and one number
    password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/
  end
  def create_password_update_record
    CreatePasswordUpdateRecordService.new(@user_id, @new_password).call
  end
  def send_password_update_confirmation
    SendPasswordUpdateConfirmationService.new(@user_id).call
  end
end
