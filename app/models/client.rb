class Client < ApplicationRecord
  has_many :orders

  validates :name, :dni, :email, presence: true
  validates_uniqueness_of :email, case_sensitive: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
