class AddShippingsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :shippings do |t|
      t.references :bid, null: false, foreign_key: true, index: true
      # Add additional columns for the shippings table here
      # Example: t.string :address, null: false

      t.timestamps
    end
  end
end
