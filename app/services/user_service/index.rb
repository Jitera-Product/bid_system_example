# rubocop:disable Style/ClassAndModuleChildren
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
  def manual_kyc_verification(id, kyc_status)
    user = User.find_by(id: id)
    raise Exception.new("User not found") if user.nil?
    user.update!(kyc_status: kyc_status)
    restrict_features(id)
    notification_message = case kyc_status
                           when 'Under Review'
                             'Your documents will be reviewed manually.'
                           when 'Verified', 'Rejected'
                             'Your KYC status has been updated.'
                           else
                             'Invalid KYC status.'
                           end
    { kyc_status: user.kyc_status, notification: notification_message }
  end
  def restrict_features(id)
    user = User.find_by(id: id)
    return if user.nil? || user.kyc_status != 'Rejected'
    # Add code here to restrict certain features for the user
    # based on their KYC status.
  end
  def kyc_process_timeout(id)
    user = User.find_by(id: id)
    return if user.nil?
    user.update!(kyc_status: 'Incomplete')
    restrict_features(id)
    notification_message = 'Your KYC process has timed out. Your status has been updated to Incomplete and certain features may be restricted until you complete the KYC process.'
    { kyc_status: user.kyc_status, notification: notification_message }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
