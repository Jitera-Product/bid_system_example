# PATH: /app/services/payment_methods/index_service.rb
# rubocop:disable Style/ClassAndModuleChildren
module PaymentMethods
  class IndexService
    def call
      get_payment_methods
    end
    private
    def get_payment_methods
      PaymentMethod.all.map do |payment_method|
        PaymentMethodSerializer.new(payment_method).as_json
      end
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
