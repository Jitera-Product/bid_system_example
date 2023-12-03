# PATH /db/migrate/20230401123567_add_user_id_to_messages.rb
class AddUserIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :user, null: false, foreign_key: true
  end
end
