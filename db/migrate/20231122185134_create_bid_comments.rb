class CreateBidComments < ActiveRecord::Migration[6.0]
  def change
    create_table :bid_comments do |t|
      t.timestamps
    end
  end
end
