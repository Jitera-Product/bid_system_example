class Wallet < ApplicationRecord
  belongs_to :user

  has_many :transactions, dependent: :destroy
  has_many :deposits, dependent: :destroy

  # validations

  validates :balance, presence: true

  validates :balance, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  # end for validations

  class << self
  end
end
