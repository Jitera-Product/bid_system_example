class PaymentMethodSerializer < ActiveModel::Serializer
  attributes :id, :name, :status
end
