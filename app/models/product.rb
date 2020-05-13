class Product < ApplicationRecord
  has_and_belongs_to_many :orders

  validates :title, :description, :stock, :price, :state, presence: true

  enum state: { visible: 'visible', hidden: 'hidden' }
end
