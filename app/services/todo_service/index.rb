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
end
