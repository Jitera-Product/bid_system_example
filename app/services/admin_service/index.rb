# rubocop:disable Style/ClassAndModuleChildren
class AdminService::Index
  include Pundit::Authorization

  attr_accessor :params, :records, :query, :total_count, :total_pages

  def initialize(params, current_user = nil)
    @params = params
    @records = Api::AdminsPolicy::Scope.new(current_user, Admin).resolve
  end

  def execute
    name_start_with
    email_start_with
    order
    paginate

    # Add the verification of the confirmation token to the execution flow if provided
    verify_confirmation_token if params[:confirmation_token].present?

    {
      admins: @records.as_json(only: [:id, :email, :name, :created_at, :updated_at]),
      total_items: @total_count,
      total_pages: @total_pages
    }
  rescue StandardError => e
    {
      error: e.message,
      status: :internal_server_error
    }
  end

  def name_start_with
    return if params.dig(:admins, :name).blank?

    @records = @records.where('name LIKE ?', "%#{params.dig(:admins, :name)}%")
  end

  def email_start_with
    return if params.dig(:admins, :email).blank?

    @records = @records.where('email LIKE ?', "%#{params.dig(:admins, :email)}%")
  end

  def order
    @records = @records.order(created_at: :desc)
  end

  def paginate
    page = params.dig(:pagination_page) || 1
    limit = params.dig(:pagination_limit) || 20

    @records = @records.page(page).per(limit)
    @total_count = @records.total_count
    @total_pages = @records.total_pages
  end

  # New method to verify confirmation token
  def verify_confirmation_token
    confirmation_token = params[:confirmation_token]
    admin = Admin.find_by(confirmation_token: confirmation_token)
    if admin && admin.confirmation_token_valid?
      admin.update(confirmed_at: Time.current, confirmation_token: nil)
      { success: 'Email confirmed successfully.' }
    elsif admin
      { error: 'Confirmation token is invalid or expired.' }
    else
      { error: 'No admin found with the provided confirmation token.' }
    end
  rescue StandardError => e
    raise AuthenticationError, e.message
  end
end
# rubocop:enable Style/ClassAndModuleChildren
