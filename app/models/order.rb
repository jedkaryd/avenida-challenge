class Order < ApplicationRecord
  belongs_to :client
  has_and_belongs_to_many :products

  validates :products, :client, presence: true
end
