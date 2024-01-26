class AddNewColumnsToBidItems < ActiveRecord::Migration[6.0]
  def up
    # Add new columns or change existing ones as per the new requirements
    # Example: add_column :bid_items, :new_column_name, :string

    # If there are any columns that need to be renamed:
    # rename_column :bid_items, :old_column_name, :new_column_name

    # If there are any columns that need to be changed:
    # change_column :bid_items, :column_name, :new_type

    # If there are any columns that need to be removed:
    # remove_column :bid_items, :old_column_name
  end

  def down
    # Add code to revert the changes made in the up method
    # Example: remove_column :bid_items, :new_column_name

    # If there were any columns renamed:
    # rename_column :bid_items, :new_column_name, :old_column_name

    # If there were any columns changed:
    # change_column :bid_items, :column_name, :old_type

    # If there were any columns added:
    # remove_column :bid_items, :new_column_name
  end
end
