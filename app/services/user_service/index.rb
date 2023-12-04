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
  def update_kyc_status(user_id, kyc_status)
    user = User.find(user_id)
    if kyc_status == 'Incomplete'
      user.update(kyc_status: 'Incomplete')
      notify_user(user_id)
    end
    user
  end
  def notify_user(user_id)
    user = User.find(user_id)
    Devise.mailer.send_notification(user.email).deliver_now
  end
  def manual_kyc_verification(id, kyc_status, status)
    user = User.find(id)
    raise "User not found" if user.nil?
    user.update!(kyc_status: 'Under Review')
    kyc_documents = KycDocument.where(user_id: id)
    kyc_documents.each do |doc|
      doc.update!(status: 'Under Review')
    end
    NotificationService.new(user, "Your documents are under review").send_notification
    user.update!(kyc_status: kyc_status)
    kyc_documents.each do |doc|
      doc.update!(status: status)
    end
    { kyc_status: user.kyc_status, message: "KYC status updated successfully" }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
