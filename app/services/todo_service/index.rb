# typed: ignore
module TodoService
  class Index < BaseService
    include ActiveModel::Validations

    attr_accessor :title, :due_date

    validates :title, presence: true, length: { maximum: 255 }
    validate :due_date_is_valid_datetime
    validate :due_date_is_not_in_past

    def initialize(title:, due_date:)
      @title = title
      @due_date = due_date
    end

    def validate_todo_creation_input
      if valid?
        { validation_result: true, error_message: nil }
      else
        { validation_result: false, error_message: errors.full_messages.join(', ') }
      end
    end

    private

    def due_date_is_valid_datetime
      errors.add(:due_date, 'must be a valid datetime') unless due_date.is_a?(DateTime)
    end

    def due_date_is_not_in_past
      errors.add(:due_date, 'cannot be in the past') if due_date < DateTime.now
    end
  end

  def link_category_to_todo(todo_id, category_id)
    todo = Todo.find_by(id: todo_id)
    raise ActiveRecord::RecordNotFound, "Todo not found" unless todo

    category = Category.find_by(id: category_id)
    raise ActiveRecord::RecordNotFound, "Category not found" unless category

    begin
      TodoCategory.create!(todo_id: todo_id, category_id: category_id)
      { success_message: "Category has been successfully linked to the todo item." }
    rescue ActiveRecord::RecordInvalid => e
      { error_message: e.message }
    end
  end

  private :link_category_to_todo
end
