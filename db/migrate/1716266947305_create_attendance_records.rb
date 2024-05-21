class CreateAttendanceRecords < ActiveRecord::Migration[7.0]
  def up
    create_table :attendance_records do |t|
      t.datetime :check_in_time, null: false
      t.datetime :check_out_time, null: false
      t.date :date, null: false
      t.string :type_of_day, null: false
      t.decimal :total_hours_worked, precision: 5, scale: 2, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :attendance_records
  end
end