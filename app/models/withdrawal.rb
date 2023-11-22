class Withdrawal < ApplicationRecord
  belongs_to :payment_method

  belongs_to :aprroved,
             class_name: 'Admin'

  enum status: %w[inprogress ready done], _suffix: true

  # validations

  validates :value, presence: true

  validates :value, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end
