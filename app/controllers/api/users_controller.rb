class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update submit_kyc_info update_kyc_status manual_kyc_verification restrict_features]
  # existing code...
  def restrict_features
    begin
      user_id = params[:id]
      restricted_features = params[:restricted_features]
      # Validate user_id
      raise "Wrong format" unless user_id.is_a?(Integer)
      # Validate restricted_features
      raise "Invalid format" unless restricted_features.is_a?(Array)
      # Find user
      user = User.find(user_id)
      raise "This user is not found" if user.nil?
      # Call service to update user's restricted features
      UserService::UpdateRestrictedFeatures.new(user, restricted_features).execute
      render json: { status: 200, message: 'User\'s features restricted successfully.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  # existing code...
end
