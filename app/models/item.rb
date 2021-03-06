require 'pry'

class Item < ActiveRecord::Base
  belongs_to :producer
  validates :count, numericality: { greater_than_or_equal_to: 0, message: "Inventory cannot be less than zero." }
  validates :price_in_cents, numericality: { greater_than_or_equal_to: 0, message: "Price cannot be less than zero." }

  def price
    cents_price_string = self.price_in_cents.to_s
    cents_price_string.prepend('0') if cents_price_string.size == 1
    dollars_and_cents = cents_price_string.match(/(\d*)(\d{2})/)
    dollars, cents = dollars_and_cents[1], dollars_and_cents[2]
    "#{dollars}.#{cents}"
  end
end