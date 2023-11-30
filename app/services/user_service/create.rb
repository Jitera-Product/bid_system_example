# typed: true
class UserService::Create < BaseService
  def initialize(params)
    @params = params
  end
  def call
    validate_input
    create_user
  end
  private
  def validate_input
    required_fields = %i[name age gender location interests preferences]
    missing_fields = required_fields.select { |field| @params[field].blank? }
    if missing_fields.any?
      return { status: :error, message: "Missing required fields: #{missing_fields.join(', ')}" }
    end
  end
  def create_user
    user = User.new(@params)
    if user.save
      { status: :success, user_id: user.id }
    else
      { status: :error, message: user.errors.full_messages.join(', ') }
    end
  end
end
