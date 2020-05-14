class Product < ApplicationRecord
  has_and_belongs_to_many :orders

  validates :title, :description, :stock, :price, :state, presence: true

  enum state: { visible: 'visible', hidden: 'hidden' }

  scope :all_visible_ones, -> { where(state: 'visible') }

  def available_stock?
    return true if stock.positive?

    false
  end

  def reduce_stock
    decrement!(:stock) if available_stock?
  end
end
