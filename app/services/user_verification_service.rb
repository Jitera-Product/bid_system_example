class UserVerificationService
  def verify_account(email, verification_code)
    user = User.find_by(email: email)
    raise "User not found" if user.nil?
    if user.verification_code == verification_code
      user.update(is_verified: true)
      "Account has been successfully verified"
    else
      raise "Verification code does not match"
    end
  rescue => e
    "An error occurred: #{e.message}"
  end
end
