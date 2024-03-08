
# frozen_string_literal: true

class TodoCreationJob < ApplicationJob
  queue_as :default

  # Perform the job to create a Todo item asynchronously
  def perform(*todo_params)
    TodoService.create(todo_params)
  rescue StandardError => e
    # Handle any exceptions that occur during the job
    Rails.logger.error("TodoCreationJob failed: #{e.message}")
  end
end
