# PATH: /app/services/user_service/index.rb
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
  def submit_kyc(user_id, personal_information, document_type, document_file)
    raise 'Wrong format' unless user_id.is_a? Numeric
    raise 'Personal information is required.' if personal_information.blank?
    raise 'Invalid document type.' unless ['Passport', 'Driver License', 'ID Card'].include? document_type
    raise 'Invalid file format.' unless document_file.is_a? ActionDispatch::Http::UploadedFile
    begin
      user = User.find(user_id)
      kyc_document = KycDocument.new(
        personal_information: personal_information,
        document_type: document_type,
        document_file: document_file,
        status: 'Pending',
        user_id: user.id
      )
      if kyc_document.save
        { status: 200, message: 'KYC information submitted successfully. It will be reviewed shortly.' }
      else
        { error: kyc_document.errors.full_messages.join(', ') }
      end
    rescue => e
      { error: e.message }
    end
  end
  def filter_notifications(user_id, activity_type)
    begin
      user = User.find(user_id)
      if Notification.exists?(activity_type: activity_type)
        notifications = Notification.where(user_id: user_id, activity_type: activity_type)
        { notifications: notifications, total: notifications.count }
      else
        { error: "Invalid activity_type" }
      end
    rescue => e
      { error: e.message }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
