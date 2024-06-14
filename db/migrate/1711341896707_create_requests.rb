class CreateRequests < ActiveRecord::Migration[6.0]
  def up
    create_table :requests do |t|
      t.integer :status, null: false
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :requests
  end
end
