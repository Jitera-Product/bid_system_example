class BidItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :start_price, :current_price, :status
end
