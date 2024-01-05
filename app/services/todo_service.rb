
class TodoService
  # existing methods...

  def check_todo_title_uniqueness(user_id, title)
    todo_exists = Todo.exists?(user_id: user_id, title: title)
    if todo_exists
      { is_unique: false, error: "A todo with the title '#{title}' already exists for this user." }
    else
      { is_unique: true }
    end
  end

  # other methods...
end
