class AddMessageCountToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :message_count, :integer, default: 0
    # Ensure that message_count cannot be null and has a default value of 0
    change_column_null :messages, :message_count, false
  end
end
