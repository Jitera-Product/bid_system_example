# frozen_string_literal: true

class TodoService
  def self.create(todo_params)
    todo = Todo.new(todo_params)

    if todo.save
      # Handle success (e.g., send notifications)
    else
      # Handle failure (e.g., log errors)
    end
  end
end
