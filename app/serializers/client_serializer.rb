class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :dni, :phone_number, :address
end
