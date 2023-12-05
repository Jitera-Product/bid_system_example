class PaymentMethodSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :name, :status
end
