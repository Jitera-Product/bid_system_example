class UpdateBidComments < ActiveRecord::Migration[6.0]
  def change
    change_table :bid_comments do |t|
      t.references :bid_item, foreign_key: true
    end
  end
end
