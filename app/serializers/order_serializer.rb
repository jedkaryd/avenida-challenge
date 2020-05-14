class OrderSerializer < ActiveModel::Serializer
  attributes :id, :client, :created_at
  has_many :products

  def client
    object.client
  end
end
