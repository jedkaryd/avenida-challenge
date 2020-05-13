class Client < ApplicationRecord
  has_many :orders

  validates :name, :dni, :email, presence: true
end
