class AttendanceRecord < ApplicationRecord
  belongs_to :user

  validates :check_in_time, presence: true
  validates :check_out_time, presence: true
  validates :date, presence: true
  validates :type_of_day, presence: true
  validates :total_hours_worked, presence: true
  validates :user_id, presence: true

  validate :unique_check_in_per_date

  private

  def unique_check_in_per_date
    if AttendanceRecord.where(user_id: user_id, date: date, check_in_time: check_in_time).exists?
      errors.add(:check_in_time, I18n.t('activerecord.errors.messages.taken'))
    end
  end
end