class Order < ApplicationRecord
  belongs_to :client
  has_and_belongs_to_many :products

  validates :products, :client, presence: true

  before_create :validates_stock_and_visibility
  after_create :updates_products_stock

  def validates_stock_and_visibility
    invalid_products = products.select { |product| product.hidden? || !product.has_stock? }
    products.delete(invalid_products)
  end

  def updates_products_stock
    products.each(&:reduce_stock)
  end
end
