class AttendanceRecord < ApplicationRecord
  belongs_to :user

  validates :check_in_time, presence: true
  validates :check_out_time, presence: true
  validates :date, presence: true
  validates :type_of_day, presence: true
  validates :total_hours_worked, presence: true
  validates :user_id, presence: true
end