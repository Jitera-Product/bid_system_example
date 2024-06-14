class Withdrawal < ApplicationRecord
  belongs_to :payment_method

  belongs_to :aprroved,
             class_name: 'Admin'

  enum status: { pending: 0, approved: 1, rejected: 2 }

  # validations

  validates :value, presence: true
  validates :status, inclusion: { in: statuses.keys, message: I18n.t('activerecord.errors.models.withdrawal.attributes.status.invalid') }

  validates :value, numericality: { greater_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end