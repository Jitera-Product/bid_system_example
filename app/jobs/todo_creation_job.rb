# frozen_string_literal: true

class TodoCreationJob < ApplicationJob
  queue_as :default

  def perform(todo_params)
    # Business logic to create a Todo item
    TodoService.create(todo_params)
  end
end
