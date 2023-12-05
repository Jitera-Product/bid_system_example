# PATH: /app/services/payment_methods/index_service.rb
# rubocop:disable Style/ClassAndModuleChildren
module PaymentMethods
  class IndexService
    def call
      PaymentMethod.all
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
