class AddNewColumnsToMessages < ActiveRecord::Migration[6.0]
  def up
    create_table :messages do |t|
      t.text :content, null: false
      t.references :chat_session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :messages
  end
end
