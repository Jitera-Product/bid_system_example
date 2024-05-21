class AttendanceRecord < ApplicationRecord
  belongs_to :user

  validates :check_in_time, presence: true
  validates :check_out_time, presence: true
  validates :date, presence: true
  validates :type_of_day, presence: true
  validates :total_hours_worked, presence: true
  validates :user_id, presence: true

  validate :unique_check_in_per_date, on: :create

  private

  def unique_check_in_per_date
    # Check for any existing record with the same user_id and date, but only if check_in_time is being set for the first time (on create)
    if AttendanceRecord.where(user_id: user_id, date: date).where.not(check_out_time: nil).exists?
      errors.add(:check_in_time, I18n.t('activerecord.errors.models.attendance_record.attributes.check_in_time.already_checked_in'))
    end
  end
end