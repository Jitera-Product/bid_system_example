# frozen_string_literal: true

class TodoService
  # Creates a new Todo item with the provided parameters
  def self.create(todo_params)
    todo = Todo.new(todo_params)

    return todo if todo.save

    # If the Todo item could not be saved, raise an exception with the errors
    raise ActiveRecord::RecordInvalid.new(todo)
  rescue ActiveRecord::RecordInvalid => e
    # Log the error and return the invalid todo object
    Rails.logger.error("TodoService::create failed: #{e.record.errors.full_messages.join(', ')}")
    e.record
  end
end
    else
      # Handle failure (e.g., log errors)
    end
  end
end
