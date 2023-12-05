# PATH: /app/services/payment_method_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class PaymentMethodService::Index
  attr_accessor :records
  def initialize
    @records = PaymentMethod.all
  end
  def execute
    {
      status: 200,
      paymentmethods: @records.map do |record|
        {
          id: record.id,
          name: record.name,
          status: record.status
        }
      end
    }
  end
  def self.call
    new.execute
  end
end
# rubocop:enable Style/ClassAndModuleChildren
