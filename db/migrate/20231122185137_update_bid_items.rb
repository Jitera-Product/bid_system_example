class UpdateBidItems < ActiveRecord::Migration[6.0]
  def up
    add_column :bid_items, :chat_session_id, :integer unless column_exists?(:bid_items, :chat_session_id)
    add_index :bid_items, :chat_session_id unless index_exists?(:bid_items, :chat_session_id)

    # Adjustments for existing columns can be placed here if needed
  end

  def down
    remove_index :bid_items, :chat_session_id if index_exists?(:bid_items, :chat_session_id)
    remove_column :bid_items, :chat_session_id if column_exists?(:bid_items, :chat_session_id)

    # Revert adjustments for existing columns if needed
  end
end
