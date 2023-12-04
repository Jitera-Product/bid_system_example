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
  def submit_kyc(id, name, kyc_status, document_type, document_file, status)
    user = User.find_by(id: id)
    return { error: 'User not found' } unless user
    kyc_document = KycDocument.new(
      name: name,
      kyc_status: kyc_status,
      document_type: document_type,
      document_file: document_file,
      status: status,
      user_id: user.id
    )
    return { error: 'Invalid input or document' } unless kyc_document.valid?
    if kyc_status == 'Verified'
      user.update(kyc_status: 'Verified')
      kyc_document.update(status: 'Verified')
    elsif kyc_status == 'Pending'
      user.update(kyc_status: 'Pending')
      kyc_document.update(status: 'Pending')
      NotificationService.notify(user, 'Your documents will be reviewed manually.')
    else
      return { error: 'Invalid KYC status' }
    end
    kyc_document.save
    { kyc_status: user.kyc_status, document_status: kyc_document.status }
  end
  def filter_notifications(user_id, activity_type)
    begin
      user = User.find(user_id)
      if Notification.exists?(activity_type: activity_type)
        notifications = Notification.where(user_id: user_id, activity_type: activity_type)
        { notifications: notifications, total: notifications.count }
      else
        { error: "Invalid activity type" }
      end
    rescue => e
      { error: e.message }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
