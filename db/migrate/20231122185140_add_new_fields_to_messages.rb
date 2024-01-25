class AddNewFieldsToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :read_at, :datetime
    # Add other new fields here following the same pattern
  end

  def down
    remove_column :messages, :read_at
    # Remove other new fields here following the same pattern
  end
end
