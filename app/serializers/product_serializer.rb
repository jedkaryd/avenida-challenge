class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :stock, :price, :state
end
