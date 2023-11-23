class CreateBidComments < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_comments do |t|
      t.references :bid_item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
