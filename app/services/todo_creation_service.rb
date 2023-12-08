class TodoCreationService
  def create_todo(user_id:, title:, due_date:)
    validation_status = true
    error_message = nil

    # Instantiate validators
    todo_validator = TodoValidator.new
    title_uniqueness_validator = TodoTitleUniquenessValidator.new
    due_date_validator = TodoDueDateValidator.new

    # Validate mandatory fields
    unless todo_validator.validate_mandatory_fields(title, due_date)
      validation_status = false
      error_message = "Title and due date are mandatory."
    end

    # Validate title uniqueness
    if validation_status && !title_uniqueness_validator.validate_title_uniqueness(user_id, title)
      validation_status = false
      error_message = "Title already exists."
    end

    # Validate due date
    if validation_status && !due_date_validator.validate_due_date(due_date)
      validation_status = false
      error_message = "Due date is not valid."
    end

    # Proceed with todo creation if validations pass
    if validation_status
      todo = Todo.new(user_id: user_id, title: title, due_date: due_date)
      if todo.save
        # Additional todo creation process can be placed here
      else
        validation_status = false
        error_message = todo.errors.full_messages.join(", ")
      end
    end

    # Return the result
    { validation_status: validation_status, error_message: error_message }
  end
end
