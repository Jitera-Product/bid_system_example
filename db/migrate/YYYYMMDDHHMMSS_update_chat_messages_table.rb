# frozen_string_literal: true

class UpdateChatMessagesTable < ActiveRecord::Migration[6.1]
  def change
    # Assuming we need to add a new column 'user_id' as a foreign key to the users table
    add_reference :chat_messages, :user, null: false, foreign_key: true

    # If there are other changes needed, they would be added here following the same pattern
    # For example, if we needed to remove an obsolete column:
    # remove_column :chat_messages, :obsolete_column_name

    # Or if we needed to rename a column:
    # rename_column :chat_messages, :old_column_name, :new_column_name

    # Or if we needed to change the type of a column:
    # change_column :chat_messages, :column_name, :new_type
  end
end
