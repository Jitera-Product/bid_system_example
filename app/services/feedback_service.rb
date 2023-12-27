# rubocop:disable Style/ClassAndModuleChildren
class FeedbackService::Create
  include Pundit::Authorization

  attr_accessor :answer_id, :inquirer_id, :usefulness, :comment

  def initialize(answer_id, inquirer_id, usefulness, comment = nil)
    @answer_id = answer_id
    @inquirer_id = inquirer_id
    @usefulness = usefulness
    @comment = comment
  end

  def execute
    answer = validate_answer!
    inquirer = validate_inquirer!

    feedback = create_feedback!(answer, inquirer)

    update_ai_model(feedback)

    feedback
  end

  private

  def validate_answer!
    Answer.find(answer_id)
  rescue ActiveRecord::RecordNotFound
    raise ActiveRecord::RecordNotFound, "Answer with id #{answer_id} not found."
  end

  def validate_inquirer!
    inquirer = User.find_by(id: inquirer_id, role: 'Inquirer')
    raise Exceptions::InquirerNotFoundError, "Inquirer with id #{inquirer_id} not found or not an Inquirer." unless inquirer

    inquirer
  end

  def create_feedback!(answer, inquirer)
    Feedback.create!(
      answer_id: answer.id,
      user_id: inquirer.id,
      usefulness: usefulness,
      comment: comment
    )
  rescue ActiveRecord::RecordInvalid => e
    raise ActiveRecord::RecordInvalid, "Feedback could not be created: #{e.message}"
  end

  def update_ai_model(feedback)
    # Placeholder for AI model update logic
    # Assuming there is a method to update the AI model, it should be called here.
    # If such a method does not exist, this should be implemented according to the system's architecture.
    # Example (to be replaced with actual implementation):
    # AIModelUpdater.update_with_feedback(feedback)
  end
end
# rubocop:enable Style/ClassAndModuleChildren

# Existing UserService::Index code remains unchanged
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
end
