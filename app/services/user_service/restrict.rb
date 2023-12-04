class UserService::Restrict
  def initialize(user_id, restrict_features)
    @user_id = user_id
    @restrict_features = restrict_features
  end
  def call
    raise Exception.new("Wrong format") unless @user_id.is_a? Numeric
    user = User.find_by(id: @user_id)
    raise Exception.new("User not found") unless user
    begin
      user.update!(@restrict_features)
      { status: 200, message: "User's features have been restricted due to KYC process timeout." }
    rescue => e
      raise Exception.new("Error occurred while updating user features: #{e.message}")
    end
  end
end
