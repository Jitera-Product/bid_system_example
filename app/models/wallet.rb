
class Wallet < ApplicationRecord
  belongs_to :user

  has_many :transactions, -> { where(deleted_at: nil) }, dependent: :destroy
  has_many :deposits, -> { where(deleted_at: nil) }, dependent: :destroy

  # validations
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0.0, message: I18n.t('activerecord.errors.messages.greater_than_or_equal_to', count: 0) }

  # Additional validations can be added here as needed, for example:
  # validates :user, presence: true
  # validates :locked, inclusion: { in: [true, false] }

  # end for validations

  def soft_delete
    update(deleted_at: Time.current)
  end

  class << self
    # If there are any class methods in either version, they should be included here.
    # Since neither the new code nor the existing code have any, this section remains empty.
  end
end
