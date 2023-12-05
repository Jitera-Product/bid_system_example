# PATH: /app/services/payment_method_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class PaymentMethodService::Index
  attr_accessor :records
  def initialize
    @records = PaymentMethod.all
  end
  def execute
    @records
  end
  def self.call
    new.execute
  end
end
# rubocop:enable Style/ClassAndModuleChildren
